//
//  StubURLProtocol.swift
//  MapTapTilerTests
//

import Foundation
import Synchronization

/// Answers every request with whatever `respond` returns, so tests never touch the network.
final class StubURLProtocol: URLProtocol {

    typealias Answer = (statusCode: Int?, data: Data?, error: Error?)

    private struct State {
        var respond: @Sendable (URLRequest) -> Answer = { _ in (200, Data(), nil) }
        var requestCount = 0
    }

    /// URLSession runs the protocol on its own threads, so the shared settings are guarded by a lock.
    private static let state = Mutex(State())

    /// What each request gets back.
    static var respond: @Sendable (URLRequest) -> Answer {
        get { state.withLock { $0.respond } }
        set { state.withLock { $0.respond = newValue } }
    }

    /// How many requests have been made.
    static var requestCount: Int {
        get { state.withLock { $0.requestCount } }
        set { state.withLock { $0.requestCount = newValue } }
    }

    static func sessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return configuration
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let respond = Self.state.withLock { state in
            state.requestCount += 1
            return state.respond
        }
        let answer = respond(request)
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
