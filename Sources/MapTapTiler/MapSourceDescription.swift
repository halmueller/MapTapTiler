//
//  MapSourceDescription.swift
//  MapTap
//
//  Created by Hal Mueller on 11/21/16.
//  Copyright © 2016 Mobile Geographics. All rights reserved.
//

import Foundation
import MapKit

@objc public class MapSourceDescription: NSObject {
    public init(name: String,
                attribution: String,
                isOpaque: Bool,
                appleMapType: MKMapType,
                isAppleMap: Bool,
                tileURLTemplate: String,
                cacheName: String,
                cacheExtension: String,
                tileWidth: Int,
                tileHeight: Int,
                isGeometryFlipped: Bool,
                refreshCacheAge: Measurement<UnitDuration> = Measurement(value: 30 * 24, unit: UnitDuration.hours),
                tooStaleCacheAge: Measurement<UnitDuration> = Measurement(value: 90 * 24, unit: UnitDuration.hours),
                minimumZ: Int,
                maximumServerZ: Int,
                maximumOverzoomZ: Int = 0) {
        self.name = name
        self.attribution = attribution
        self.isOpaque = isOpaque
        self.appleMapType = appleMapType
        self.isAppleMap = isAppleMap
        self.tileURLTemplate = tileURLTemplate
        self.cacheName = cacheName
        self.cacheExtension = cacheExtension
        self.tileWidth = tileWidth
        self.tileHeight = tileHeight
        self.isGeometryFlipped = isGeometryFlipped
        self.refreshCacheAgeSeconds = refreshCacheAge.converted(to: .seconds).value
        self.tooStaleCacheAgeSeconds = tooStaleCacheAge.converted(to: .seconds).value
        self.minimumZ = minimumZ
        self.maximumServerZ = maximumServerZ
        self.maximumOverzoomZ = maximumOverzoomZ
    }
    
    public let name: String
    public let attribution: String
    public let webpageURLString: String? = nil
    public let legendURLString: String? = nil
    public let isOpaque: Bool

    /// Tiles older than this age should be refreshed from source if possible.
    public let refreshCacheAgeSeconds: TimeInterval

    // TODO: Use/honor this value.
    /// Tiles older than this age must not be displayed, even if new tiles are unavailable. Not yet implemented. Note that this is not the best way
    /// to have tiles expire in cases where we know the precise future date of the next map update (for iinstance, aviation charts).
    public let tooStaleCacheAgeSeconds: TimeInterval

    /// What Apple map type do we use as the underlay/basemap?
    public let appleMapType: MKMapType
    public let isAppleMap: Bool
    
    // for MKTileOverlay creation:
    public let tileURLTemplate: String
    public let cacheName: String
    public let cacheExtension: String
    public let tileWidth: Int
    public let tileHeight: Int
    public let isGeometryFlipped: Bool
    public let minimumZ: Int
    public let maximumServerZ: Int
    /// Not yet implemented. Allows for situations where we want to zoom in beyond what the server will deliver, and we don't mind blocky looking supersize pixels.
    public let maximumOverzoomZ: Int

    // later add: round-robin tileservers, retina scale
/*
 MKTileOverlay: Accessing the Tile Attributes

    var
    The size (in pixels) of your tile images.
    var isGeometryFlipped: Bool
    A Boolean value that indicates the orientation of tile indexes along the y axis.
    var minimumZ: Int
    The minimum zoom level supported by the tiles of this overlay object.
    var maximumZ: Int
    The maximum zoom level supported by the tiles of this overlay object.
    var canReplaceMapContent: Bool
    A Boolean value that indicates whether the tile content is fully opaque.
    Customizing the Loading of Tiles

    var urlTemplate: String?
    The template for generating tile image URLs.
*/
}
