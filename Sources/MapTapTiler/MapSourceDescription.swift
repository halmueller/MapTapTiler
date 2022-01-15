//
//  MapSourceDescription.swift
//  MapTap
//
//  Created by Hal Mueller on 11/21/16.
//  Copyright © 2016 Mobile Geographics. All rights reserved.
//

import Foundation
import MapKit

public struct MapSourceDescription {
    public let identifier: MapSourceIdentifier
    public let name: String
    public let attribution: String
    public let isOpaque: Bool

    public let appleMapType: MKMapType
    public let isAppleMap: Bool
    
    // for MKTileOverlay creation:
    let tileURLTemplate: String
    let cacheName: String
	let cacheExtension: String
    let tileWidth: Double
    public let tileHeight: Double
    public let isGeometryFlipped: Bool
    public let minimumZ: Int
    public let maximumServerZ: Int
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
