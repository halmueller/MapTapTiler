import MapKit
import XCTest
@testable import MapTapTiler

/// Tests that ExternalTileOverlay always answers MapKit, whatever the server does, and uses its cache sensibly.
final class MapTapTilerTests: XCTestCase {

    private let path = MKTileOverlayPath(x: 3, y: 5, z: 4, contentScaleFactor: 2)
    private let tileData = Data("tile".utf8)
    private var cacheName = ""

    override func setUp() {
        super.setUp()
        cacheName = "MapTapTilerTests-\(UUID().uuidString)"
        StubURLProtocol.requestCount = 0
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: cacheFolder())
        super.tearDown()
    }

    // MARK: - Helpers

    /// An overlay that refreshes tiles older than an hour and never shows tiles older than a day.
    private func makeOverlay() -> ExternalTileOverlay {
        let description = MapSourceDescription(
            name: "Test", attribution: "Test", isOpaque: false, appleMapType: .standard, isAppleMap: false,
            tileURLTemplate: "https://tiles.example.com/{z}/{x}/{y}.png", cacheName: cacheName, cacheExtension: "png",
            tileWidth: 256, tileHeight: 256, isGeometryFlipped: false,
            refreshCacheAge: Measurement(value: 1, unit: .hours),
            tooStaleCacheAge: Measurement(value: 24, unit: .hours),
            minimumZ: 0, maximumServerZ: 19)
        return ExternalTileOverlay(sourceDescription: description,
                                   sessionConfiguration: StubURLProtocol.sessionConfiguration())
    }

    private func cacheFolder() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("tilecache/\(cacheName)", isDirectory: true)
    }

    private func cachedTileURL() -> URL {
        cacheFolder().appendingPathComponent("\(path.contentScaleFactor)/\(path.z)/\(path.x)/\(path.y).png")
    }

    private func writeCachedTile(_ data: Data, hoursOld: Double) throws {
        let url = cachedTileURL()
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url)
        try FileManager.default.setAttributes([.modificationDate: Date(timeIntervalSinceNow: -hoursOld * 3600)],
                                              ofItemAtPath: url.path)
    }

    /// Loads the tile and returns what the overlay passed to its callback, failing if it never calls back.
    private func load(_ overlay: ExternalTileOverlay) -> (data: Data?, error: Error?) {
        let called = expectation(description: "result called")
        var outcome: (Data?, Error?) = (nil, nil)
        overlay.loadTile(at: path) { data, error in
            outcome = (data, error)
            called.fulfill()
        }
        wait(for: [called], timeout: 5)
        return outcome
    }

    // MARK: - Server answers

    func testTileIsReturnedAndCached() {
        StubURLProtocol.respond = { [tileData] _ in (200, tileData, nil) }
        let outcome = load(makeOverlay())
        XCTAssertEqual(outcome.data, tileData)
        XCTAssertNil(outcome.error)
        XCTAssertEqual(try? Data(contentsOf: cachedTileURL()), tileData)
    }

    func testNotFoundMeansNoTile() {
        StubURLProtocol.respond = { _ in (404, Data("Not Found".utf8), nil) }
        let outcome = load(makeOverlay())
        XCTAssertNil(outcome.data)
        XCTAssertNil(outcome.error)
    }

    func testServerErrorIsReported() {
        StubURLProtocol.respond = { _ in (503, nil, nil) }
        let outcome = load(makeOverlay())
        XCTAssertNil(outcome.data)
        XCTAssertNotNil(outcome.error)
    }

    func testNetworkFailureIsReported() {
        StubURLProtocol.respond = { _ in (nil, nil, URLError(.timedOut)) }
        let outcome = load(makeOverlay())
        XCTAssertNil(outcome.data)
        XCTAssertEqual((outcome.error as? URLError)?.code, .timedOut)
    }

    // MARK: - Cache

    func testFreshCachedTileSkipsTheServer() throws {
        try writeCachedTile(tileData, hoursOld: 0.5)
        StubURLProtocol.respond = { _ in (500, nil, nil) }
        let outcome = load(makeOverlay())
        XCTAssertEqual(outcome.data, tileData)
        XCTAssertEqual(StubURLProtocol.requestCount, 0)
    }

    func testOldCachedTileIsRefreshed() throws {
        try writeCachedTile(Data("old".utf8), hoursOld: 2)
        StubURLProtocol.respond = { [tileData] _ in (200, tileData, nil) }
        let outcome = load(makeOverlay())
        XCTAssertEqual(outcome.data, tileData)
        XCTAssertEqual(StubURLProtocol.requestCount, 1)
    }

    func testFailedRefreshFallsBackToTheOldTile() throws {
        let oldTile = Data("old".utf8)
        try writeCachedTile(oldTile, hoursOld: 2)
        StubURLProtocol.respond = { _ in (nil, nil, URLError(.notConnectedToInternet)) }
        let outcome = load(makeOverlay())
        XCTAssertEqual(outcome.data, oldTile)
        XCTAssertNil(outcome.error)
    }

    func testOverloaded404FallsBackToTheOldTile() throws {
        // Open Sea Map also answers 404 when it's overloaded, so keep showing what was there.
        let oldTile = Data("old".utf8)
        try writeCachedTile(oldTile, hoursOld: 2)
        StubURLProtocol.respond = { _ in (404, nil, nil) }
        XCTAssertEqual(load(makeOverlay()).data, oldTile)
    }

    func testTooStaleTileIsNotShown() throws {
        try writeCachedTile(Data("ancient".utf8), hoursOld: 48)
        StubURLProtocol.respond = { _ in (nil, nil, URLError(.timedOut)) }
        let outcome = load(makeOverlay())
        XCTAssertNil(outcome.data)
        XCTAssertNotNil(outcome.error)
    }
}
