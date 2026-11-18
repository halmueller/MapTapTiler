//
//  StubURLProtocol.swift
//  MapTapTilerTests
//

import Foundation

/// Answers every request with whatever `respond` returns, so tests never touch the network.
final class StubURLProtocol: URLProtocol {

    /// What the next request gets back, and a count of requests made.
    static var respond: (URLRequest) -> (statusCode: Int?, data: Data?, error: Error?) = { _ in (200, Data(), nil) }
    static var requestCount = 0

    static func sessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return configuration
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        Self.requestCount += 1
        let answer = Self.respond(request)
        if let error = answer.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        if let statusCode = answer.statusCode, let url = request.url,
           let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1",
                                          headerFields: ["Content-Type": "image/png"]) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = answer.data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
