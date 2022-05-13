//
//  ExternalTileOverlay.swift
//  MapTap
//
//  Created by Hal Mueller on 11/21/16.
//  Copyright © 2016 Mobile Geographics. All rights reserved.
//

import MapKit

@objc public class ExternalTileOverlay: MKTileOverlay {
    let parentDirectory = "tilecache"
    /// Tiles older than this age should be refreshed from source if possible.
    public let refreshCacheAgeSeconds: TimeInterval
    /// Tiles older than this age must not be displayed, even if new tiles are unavailable.
    public let tooStaleCacheAgeSeconds: TimeInterval
    var urlSession: URLSession?
    let cacheName: String
	let cacheExtension: String
    let maximumServerZ: Int

    @objc public init(sourceDescription: MapSourceDescription) {
        self.cacheName = sourceDescription.cacheName
		self.cacheExtension = sourceDescription.cacheExtension
        self.maximumServerZ = sourceDescription.maximumServerZ
        self.refreshCacheAgeSeconds = sourceDescription.refreshCacheAgeSeconds
        self.tooStaleCacheAgeSeconds = sourceDescription.tooStaleCacheAgeSeconds
        
        super.init(urlTemplate: sourceDescription.tileURLTemplate)
        self.minimumZ = sourceDescription.minimumZ
        self.maximumZ = sourceDescription.maximumOverzoomZ
        self.canReplaceMapContent = sourceDescription.isOpaque
		self.tileSize = CGSize(width: sourceDescription.tileWidth, height: sourceDescription.tileHeight)

        // The Open Sea Map tile server returns 404 for blank tiles, and also when it's
        // too heavily loaded to return a tile. Maybe some other sources do too? We'll
        // do our own cacheing and not use NSURLSession's.
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.urlCache = nil
        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.urlSession = URLSession(configuration: sessionConfiguration)

		#if targetEnvironment(simulator)
		let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
		let cachesDirectory = paths[0]
        debugPrint("Caches Directory:\nopen ")
		debugPrint(cachesDirectory)
		#endif
    }

//    public override func url(forTilePath path: MKTileOverlayPath) -> URL {
//		if sourceIdentifier == .NRLDNC || sourceIdentifier == .NRLENC {
//			// These two sources (and maybe all NRL sources?) start the Z tiling scale at 1, not 0, and have a Y offset of 1000
//			let substitutePath = MKTileOverlayPath(x: path.x, y: path.y - 1000, z: path.z + 1, contentScaleFactor: path.contentScaleFactor)
//			return super.url(forTilePath: substitutePath)
//		}
//		return super.url(forTilePath: path)
//	}

    @objc public override func loadTile(at path: MKTileOverlayPath, result: @escaping (Data?, Error?) -> Void) {

        let overzoomMode = path.z > maximumServerZ
        if overzoomMode {
            // we're in overzoom mode
            let overzoom = path.z - maximumServerZ
        }

        let parentXFolderURL = URLForTilecacheFolder().appendingPathComponent(self.cacheXFolderNameForPath(path))
        let tileFilePathURL = parentXFolderURL.appendingPathComponent(fileNameForTile(path))
        let tileFilePath = tileFilePathURL.path
        var useCachedVersion = false
        if FileManager.default.fileExists(atPath: tileFilePath) {
            if let fileAttributes = try? FileManager.default.attributesOfItem(atPath: tileFilePath),
                let fileModificationDate = fileAttributes[FileAttributeKey.modificationDate] as? Date {
                if fileModificationDate.timeIntervalSinceNow > -1.0 * refreshCacheAgeSeconds {
                    useCachedVersion = true
                }
            }
        }
        if (useCachedVersion) {
            let cachedData = try? Data(contentsOf: URL(fileURLWithPath: tileFilePath))
            result(cachedData, nil)
        }
        else {
            let request = URLRequest(url: self.url(forTilePath: path))
			#if targetEnvironment(simulator)
			debugPrint(#function, "fetching", request)
			#endif
            let task = urlSession!.dataTask(with: request, completionHandler: { (data, response, error)  in
                if response != nil {
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            do {
                                try FileManager.default.createDirectory(at: parentXFolderURL,
                                                                        withIntermediateDirectories: true, attributes: nil)
                            } catch {
                            }
                            if !((try? data!.write(to: URL(fileURLWithPath: tileFilePath), options: [.atomic])) != nil) {
								debugPrint("cache write failure", tileFilePath)
                            }
                            result(data, error as NSError?)
                        }
						else {
							#if targetEnvironment(simulator)
                            debugPrint(#function, httpResponse.statusCode, httpResponse.debugDescription)
							#endif
						}
                    }
                }
            })
            task.resume()
        }
    }

    // filename for y.png/y.jpg, used within the cacheXFolderNameForPath
    fileprivate func fileNameForTile(_ path: MKTileOverlayPath) -> String {
        return "\(path.y).\(cacheExtension)"
    }

    // path to X folder, starting from URLForTilecacheFolder
    fileprivate func cacheXFolderNameForPath(_ path: MKTileOverlayPath) -> String {
        return "\(cacheName)/\(path.contentScaleFactor)/\(path.z)/\(path.x)"
    }

    // folder within app's Library/Caches to use for this particular overlay
    fileprivate func URLForTilecacheFolder() -> URL {
        let URLForAppCacheFolder : URL = try! FileManager.default.url(for: FileManager.SearchPathDirectory.cachesDirectory,
                                                                      in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true)
        return URLForAppCacheFolder.appendingPathComponent(parentDirectory, isDirectory: true)
    }

    fileprivate func URLForXFolder(_ path: MKTileOverlayPath) -> URL {
        return URLForTilecacheFolder().appendingPathComponent(cacheXFolderNameForPath(path), isDirectory: true)
    }
    
/*
 From https://stackoverflow.com/a/69148976/719690
 
    func tiles(in rect: MKMapRect, zoomScale scale: MKZoomScale) -> [ImageTile]? {
        var z = zoomScaleToZoomLevel(scale)
        
        // OverZoom Mode - Detect when we are zoomed beyond the tile set.
        var overZoom = 1
        let zoomCap = MAX_ZOOM // A constant set to the max tile set depth.
        
        if z > zoomCap {
            // overZoom progression: 1, 2, 4, 8, etc...
            overZoom = Int(pow(2, Double(z - zoomCap)))
            z = zoomCap
        }
        
        // When we are zoomed in beyond the tile set, use the tiles
        // from the maximum z-depth, but render them larger.
        let adjustedTileSize = overZoom * Int(TILE_SIZE)
        
        // Number of tiles wide or high (but not wide * high)
        let tilesAtZ = Int(pow(2, Double(z)))
        
        let minX = Int(floor((rect.minX * Double(scale)) / Double(adjustedTileSize)))
        let maxX = Int(floor((rect.maxX * Double(scale)) / Double(adjustedTileSize)))
        let minY = Int(floor((rect.minY * Double(scale)) / Double(adjustedTileSize)))
        let maxY = Int(floor((rect.maxY * Double(scale)) / Double(adjustedTileSize)))
        var tiles: [ImageTile]? = nil
        
        for x in minX...maxX {
            for y in minY...maxY {
                
                if let url = directoryUrl?.appendingPathComponent("TopoMaps/\(z)/\(x)/\(y)_\(x)_\(z).png").relativePath,
                   FileManager.default.fileExists(atPath: url) {
                    if tiles == nil {
                        tiles = []
                    }
                    let frame = MKMapRect(
                        x: Double(x * adjustedTileSize) / Double(scale),
                        y: Double(y * adjustedTileSize) / Double(scale),
                        width: Double(CGFloat(adjustedTileSize) / scale),
                        height: Double(CGFloat(adjustedTileSize) / scale))
                    let tile = ImageTile(frame: frame, path: url)
                    tiles?.append(tile)
                }
            }
            
        }
        return tiles
        
    }
    
}

struct ImageTile {
    let frame: MKMapRect
    let path: String
}

class TileOverlayRenderer: MKOverlayRenderer {
    override func draw(
        _ mapRect: MKMapRect,
        zoomScale: MKZoomScale,
        in context: CGContext
    ) {
        // OverZoom Mode - Detect when we are zoomed beyond the tile set.
        let z = zoomScaleToZoomLevel(zoomScale)
        var overZoom = 1
        let zoomCap = MAX_ZOOM
        
        if z > zoomCap {
            // overZoom progression: 1, 2, 4, 8, etc...
            overZoom = Int(pow(2, Double(z - zoomCap)))
        }
        
        let tileOverlay = overlay as? TileOverlay
        
        // Get the list of tile images from the model object for this mapRect.  The
        // list may be 1 or more images (but not 0 because canDrawMapRect would have
        // returned NO in that case).
        
        let tilesInRect = tileOverlay?.tiles(in: mapRect, zoomScale: zoomScale)
        let tileAlpha: CGFloat = 1
        context.setAlpha(tileAlpha)
        
        for tile in tilesInRect ?? [] {
            // For each image tile, draw it in its corresponding MKMapRect frame
            let rect = self.rect(for: tile.frame)
            let image = UIImage(contentsOfFile: tile.path)
            context.saveGState()
            context.translateBy(x: rect.minX, y: rect.minY)
            
            if let cgImage = image?.cgImage, let width = image?.size.width, let height = image?.size.height {
                // OverZoom mode - 1 when using tiles as is, 2, 4, 8 etc when overzoomed.
                context.scaleBy(x: CGFloat(CGFloat(overZoom) / zoomScale), y: CGFloat(CGFloat(overZoom) / zoomScale))
                context.translateBy(x: 0, y: image?.size.height ?? 0.0)
                context.scaleBy(x: 1, y: -1)
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
                context.restoreGState()
                
                // Added release here because "Analyze" was reporting a potential leak. Bug in Apple's sample code?
            }
            
        }
    }
}

let MAX_ZOOM = 13
let TILE_SIZE: Double = 256

func zoomScaleToZoomLevel(_ scale: MKZoomScale) -> Int {
    let numTilesAt1_0 = MKMapSize.world.width / TILE_SIZE
    let zoomLevelAt1_0 = log2(numTilesAt1_0) // add 1 because the convention skips a virtual level with 1 tile.
    let zoomLevel = Int(max(0, zoomLevelAt1_0 + floor(Double(log2f(Float(scale))) + 0.5)))
    return zoomLevel
}
*/
}
