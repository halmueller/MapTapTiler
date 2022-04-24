//
//  MapLibrary.swift
//  MapTap
//
//  Created by Hal Mueller on 12/7/16.
//  Copyright © 2016 Mobile Geographics. All rights reserved.
//

import Foundation
import MapKit

let mapStyleKeystring = "mapStyle"

@available(tvOS 11.0, iOS 11.0, macOS 10.13, *)
/// This class is not needed for the core functionality, but is an example of how you might configure a library of layers.
public class MapLibrary {
    public let basemapSourceDescriptions: [MapSourceDescription]
    public let overlaySourceDescriptions: [MapSourceDescription]
    public var selectedBasemapIndex = UserDefaults.standard.integer(forKey: mapStyleKeystring) {
		didSet {
			UserDefaults.standard.set(selectedBasemapIndex, forKey: mapStyleKeystring)
		}
	}
    public var selectedOverlayIndex = -1

    public init(basemapSourceDescriptions: [MapSourceDescription]) {
		overlaySourceDescriptions = []
		self.basemapSourceDescriptions = basemapSourceDescriptions
		selectedBasemapIndex = min(selectedBasemapIndex, self.basemapSourceDescriptions.count - 1) // in csae we've decreased number of sources
	}

    public func basemapSourceDescription () -> MapSourceDescription {
		return basemapSourceDescriptions[selectedBasemapIndex]
	}
	
    public func overlaySourceDescription () -> MapSourceDescription? {
		if selectedOverlayIndex >= 0 {
		return overlaySourceDescriptions[selectedOverlayIndex]
		}
		return nil
	}

    public static func standardLibrary () -> MapLibrary {
        let standardUnderlayMapType = MKMapType.mutedStandard

        let appleStandardDef = MapSourceDescription(name: "Apple Standard", attribution: "Apple Maps", isOpaque: true, appleMapType: MKMapType.standard, isAppleMap: true,
                                                    tileURLTemplate: "", cacheName: "", cacheExtension: "", tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 19, maximumOverzoomZ: 19)
		let appleSatelliteDef = MapSourceDescription(name: "Apple Satellite", attribution: "Apple Maps", isOpaque: true, appleMapType: MKMapType.satellite, isAppleMap: true,
		                                             tileURLTemplate: "", cacheName: "", cacheExtension: "", tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 19, maximumOverzoomZ: 19)
		let appleHybridDef = MapSourceDescription(name: "Apple Hybrid", attribution: "Apple Maps", isOpaque: true, appleMapType: MKMapType.hybrid, isAppleMap: true,
		                                          tileURLTemplate: "", cacheName: "", cacheExtension: "", tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 19, maximumOverzoomZ: 19)

        let openStreetMap = MapSourceDescription(name: "OpenStreetMap", attribution: "OpenStreetMap default map", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                                 tileURLTemplate: "https://b.tile.openstreetmap.org/{z}/{x}/{y}.png", cacheName: "OpenStreetMap", cacheExtension: "png",
                                                 tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 19, maximumOverzoomZ: 19)

		let stamenTerrain = MapSourceDescription(name: "Stamen Terrain", attribution: "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL. Stamen Design rendering of OpenStreetMap data", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
												 tileURLTemplate: "http://tile.stamen.com/terrain/{z}/{x}/{y}.png", cacheName: "StamenTerrain", cacheExtension: "png",
												 tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 18, maximumOverzoomZ: 19)

		let stamenToner = MapSourceDescription(name: "Stamen Toner", attribution: "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL. Stamen Design rendering of OpenStreetMap data", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
												 tileURLTemplate: "http://tile.stamen.com/toner/{z}/{x}/{y}.png", cacheName: "StamenToner", cacheExtension: "png",
												 tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 18, maximumOverzoomZ: 19)

		let USGSTopo = MapSourceDescription(name: "USGS Topo", attribution: "USGS", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
		                                    tileURLTemplate: "https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}", cacheName: "USGSTopo", cacheExtension: "png",
		                                    tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 16, maximumOverzoomZ: 19)

        // https://b.tile.opentopomap.org/13/1309/2856.png
        let openTopoMap = MapSourceDescription(name: "OpenTopoMap", attribution: "OpenTopoMap", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                                 tileURLTemplate: "https://b.tile.opentopomap.org/{z}/{x}/{y}.png", cacheName: "OpenTopoMap", cacheExtension: "png",
                                                 tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 19, maximumOverzoomZ: 19)
        
		let USGSShadedRelief = MapSourceDescription(name: "USGS Shaded Relief", attribution: "USGS", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
		                                            tileURLTemplate: "https://basemap.nationalmap.gov/arcgis/rest/services/USGSShadedReliefOnly/MapServer/tile/{z}/{y}/{x}", cacheName: "USGSRelief", cacheExtension: "png",
		                                    tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 16, maximumOverzoomZ: 19)

		// https://basemap.nationalmap.gov/arcgis/rest/services/USGSHydroCached/MapServer/tile/6/22/13
		let USGSHydro = MapSourceDescription(name: "USGS Hydro NHD", attribution: "USGS National Hydrography Dataset", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
											 tileURLTemplate: "https://basemap.nationalmap.gov/arcgis/rest/services/USGSHydroCached/MapServer/tile/{z}/{y}/{x}",
											 cacheName: "USGSHydroNHD", cacheExtension: "png",
		                                    tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 16, maximumOverzoomZ: 19)

		let USGSImagery = MapSourceDescription(name: "USGS Imagery", attribution: "USGS", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
		                                    tileURLTemplate: "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}", cacheName: "USGSImageryOnly", cacheExtension: "png",
		                                    tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 16, maximumOverzoomZ: 19)

		let USGSImageryTopo = MapSourceDescription(name: "USGS Topo and Imagery", attribution: "USGS", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
		                                    tileURLTemplate: "https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/{z}/{y}/{x}", cacheName: "USGSImageryTopo", cacheExtension: "png",
		                                    tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 16, maximumOverzoomZ: 19)

		// http://tileservice.charts.noaa.gov/tiles/50000_1/8/41/88.png
		let RNCs = MapSourceDescription(name: "NOAA Raster Nautical Chart", attribution: "NOAA", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
										tileURLTemplate: "https://tileservice.charts.noaa.gov/tiles/50000_1/{z}/{x}/{y}.png", cacheName: "NOAARNC", cacheExtension: "png",
										tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 16, maximumOverzoomZ: 19)

		// https://maps-for-free.com/layer/relief/z6/row22/6_10-22.jpg
		let shuttleRadar = MapSourceDescription(name: "SRTM", attribution: "Shuttle Radar Topography Mission from Maps-for-free.com", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
												tileURLTemplate: "https://maps-for-free.com/layer/relief/z{z}/row{y}/{z}_{x}-{y}.jpg", cacheName: "shuttleRadar", cacheExtension: "jpg",
												tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 11, maximumOverzoomZ: 19)

		// super.init(urlTemplate: "http://tiles.openseamap.org/seamark/{z}/{x}/{y}.png")
		let openSeaMap = MapSourceDescription(name: "Open Sea Map", attribution: "Open Sea Map",
											  isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
											  tileURLTemplate: "https://tiles.openseamap.org/seamark/{z}/{x}/{y}.png", cacheName: "openSeaMap", cacheExtension: "png",
											  tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 18, maximumOverzoomZ: 19)

        // https://c.tiles.openrailwaymap.org/standard/15/5244/11438.png
        // https://www.openrailwaymap.org//legend-generator.php?zoom=14&style=standard&lang=null
        let openRailMap = MapSourceDescription(name: "Open Railway Map",
                                               attribution: "Open Railway Map",
                                               isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                               tileURLTemplate: "https://c.tiles.openrailwaymap.org/standard/{z}/{x}/{y}.png", cacheName: "openRailwayMap", cacheExtension: "png",
                                               tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 20, maximumOverzoomZ: 20)
        
        // https://c.tiles.openrailwaymap.org/maxspeed/15/5244/11438.png
        let openRailMapMaxSpeed = MapSourceDescription(name: "Open Railway Map (max speeds)",
                                               attribution: "Open Railway Map (max speeds)",
                                               isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                               tileURLTemplate: "https://c.tiles.openrailwaymap.org/maxspeed/{z}/{x}/{y}.png", cacheName: "openRailwayMapMaxSpeeds", cacheExtension: "png",
                                               tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 20, maximumOverzoomZ: 20)
        
        // https://c.tiles.openrailwaymap.org/signals/15/5244/11438.png
        let openRailMapSignals = MapSourceDescription(name: "Open Railway Map (signals)",
                                               attribution: "Open Railway Map (signals)",
                                               isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                               tileURLTemplate: "https://c.tiles.openrailwaymap.org/signals/{z}/{x}/{y}.png", cacheName: "openRailwayMapSignals", cacheExtension: "png",
                                               tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 20, maximumOverzoomZ: 20)
        
        // https://c.tile.thunderforest.com/cycle/6/35/20.png?apikey=a5dd6a2f1c934394bce6b0fb077203eb
        // legend: https://www.opencyclemap.org/docs/
        // API key required: https://www.thunderforest.com/pricing/
        let openCycleMap = MapSourceDescription(name: "Open Cycle Map",
												attribution: "Open Cycle Map",
												isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
												tileURLTemplate: "https://tiles.thunderforest.com/cycle/{z}/{x}/{y}.png", cacheName: "openCycleMap", cacheExtension: "png",
												tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 19, maximumOverzoomZ: 19)

        // http://a.tile.openstreetmap.fr/hot/${z}/${x}/${y}.png
        let hotOSMMap = MapSourceDescription(name: "HOT OSM",
                                                 attribution: "Humanitarian Open Street Map",
                                                 isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                                 tileURLTemplate: "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png", cacheName: "HOTOSMMap", cacheExtension: "png",
                                                 tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 19, maximumOverzoomZ: 19)

        // https://waymarkedtrails.org
        // https://tile.waymarkedtrails.org/hiking/5/5/11.png
        let openHikingMap = MapSourceDescription(name: "Open Hiking Map",
                                                 attribution: "Open Hiking Map",
                                                 isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                                 tileURLTemplate: "https://tile.waymarkedtrails.org/hiking/{z}/{x}/{y}.png", cacheName: "openHikingMap", cacheExtension: "png",
                                                 tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 19, maximumOverzoomZ: 19)
        
        // There are many other layers available at https://esp.usdoj.gov/arcweb/rest/services.
        // https://esp.usdoj.gov/arcweb/rest/services/World_Ocean_Base/MapServer/tile/0/0/0
        let worldOceanBase = MapSourceDescription(name: "World Ocean Base",
                                                 attribution: "World Ocean Base",
                                                 isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                                 tileURLTemplate: "https://esp.usdoj.gov/arcweb/rest/services/World_Ocean_Base/MapServer/tile/{z}/{y}/{x}", cacheName: "worldOceanBase", cacheExtension: "jpg",
                                                 tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 1, maximumServerZ: 16, maximumOverzoomZ: 16)
        
        let mapLibrary = MapLibrary(basemapSourceDescriptions: [appleStandardDef,
                                                                openStreetMap,
                                                                stamenToner,
                                                                openTopoMap,
                                                                USGSTopo,
                                                                appleHybridDef,
                                                                USGSImageryTopo,
                                                                appleSatelliteDef,
                                                                USGSImagery,
                                                                stamenTerrain,
                                                                shuttleRadar,
                                                                USGSShadedRelief,
                                                                USGSHydro,
                                                                RNCs,
                                                                openSeaMap,
                                                                hotOSMMap,
                                                                //	openHikingMap,
                                                                openRailMap,
                                                                openRailMapMaxSpeed,
                                                                openRailMapSignals,
                                                                worldOceanBase,
                                                               ])

		return mapLibrary
	}
}

