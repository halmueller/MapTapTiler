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

        // https://tile.waymarkedtrails.org/hiking/5/5/11.png
        let openHikingMap = MapSourceDescription(name: "Open Hiking Map",
                                                 attribution: "Open Hiking Map",
                                                 isOpaque: false, appleMapType: standardUnderlayMapType, isAppleMap: false,
                                                 tileURLTemplate: "https://tile.waymarkedtrails.org/hiking/{z}/{x}/{y}.png", cacheName: "openHikingMap", cacheExtension: "png",
                                                 tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 19, maximumOverzoomZ: 19)
        
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
																// Landsat7, Bluemarble, DTED, ETOPO, DNC, ENC, sectionals, WACs, TACs, // NRL, not running as of April 2018
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

/* Overzoom mode:
 https://stackoverflow.com/q/4417545/719690
 */

/*
 Other possible tileservers:
 https://geoint.nrlssc.org/tsclient/. Landsat7, Bluemarble, DTED, ETOPO, DNC, ENC, sectionals, WACs, TACs, more.
 
 https://wiki.openstreetmap.org/wiki/Tile_servers. Long list. Includes multiple cycling/hiking/horse overlays.
 
 https://directory.spatineo.com/service/691/ entry for NRL SSC. Other sources on this server?
 
 https://openmaptiles.org/docs/host/tileserver-gl/
 
 CyclOSM: https://c.tile-cyclosm.openstreetmap.fr (That's what QTH.app uses for cycle layer). See https://www.cyclosm.org/#map=12/52.3728/4.8936/cyclosm. Max zoom is 16, see https://a.tile-cyclosm.openstreetmap.fr/cyclosm/16/10485/22863.png
     https://a.tile-cyclosm.openstreetmap.fr/cyclosm/13/4204/2690.png
 
 Stamen watercolor (now worldwide): http://maps.stamen.com/watercolor/#4/37.77/-122.45
 
 Stamen:
 http://maps.stamen.com/terrain-background/#12/37.7707/-122.3781
 http://maps.stamen.com/terrain-lines/#12/37.7707/-122.3781
 http://maps.stamen.com/terrain-labels/#12/37.7707/-122.3781
 http://maps.stamen.com/terrain/#12/37.7707/-122.3781
 
 http://maps.stamen.com/toner-lite/#12/37.7707/-122.3781
 http://maps.stamen.com/toner-background/#12/37.7707/-122.3781
 http://maps.stamen.com/toner-lines/#12/37.7707/-122.3781
 http://maps.stamen.com/toner-labels/#12/37.7707/-122.3781
 http://maps.stamen.com/toner-hybrid/#12/37.7707/-122.3781
 http://maps.stamen.com/toner/#12/37.7707/-122.3781
 
 Weather:
 https://openweathermap.org/api. 'https://tile.openweathermap.org/map/clouds_new/{z}/{x}/{y}.png?appid=YOUR_APP_ID'
 https://www.aerisweather.com/support/docs/aeris-maps/map-access/map-tiles/
 https://www.weather.gov/gis/WebServices
 https://docs.meteoblue.com/en/weather-apis/maps-api/inventory-api. https://docs.meteoblue.com/en/weather-apis/maps-api/tile-api.
 https://truweathersolutions.com
 
 Aviation:
 http://vfrmap.com/20211230/tiles/vfrc/11/1335/323.jpg
 http://vfrmap.com/about.html
 
Ocean:
 https://www.gebco.net
 
 */
/*
 public enum MapSourceIdentifier: Int {
	case appleStandard = 0
	case appleHybrid
	case appleSatellite
	case openStreetMap
	case stamenTerrain
	case stamenToner
	case USGSTopo
	case USGSShadedRelief
	case USGSImagery
	case USGSImageryTopo
	case USGSHydroNHD
	case NRLLandsat7
	case NRLBluemarble
	case NRLDTED
	case NRLDNC
	case NRLETOPO
	case NRLENC
	case NRLFAASectionals
	case NRLFAATAC
	case NRLFAAWAC
	case NOAARNC
	case SRTM
	case openSeaMap
	case openRailwayMap
	case openCycleMap
	case openHikingMap
    case openTopoMap
    case openRailwayMapMaxSpeed
    case openRailwayMapSignals
    case worldOceanBase
	// later: Open Sea Map, Railway Map, Terrain Map; Stamen; Mapillary; HOT OSM. USGS.
}
 */

// http://basemap.nationalmap.gov/arcgis/rest/services
//                       https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/15/11580/5738
//super.init(urlTemplate: "https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}")
// http://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer
//super.init(urlTemplate: "http://basemap.nationalmap.gov/arcgis/rest/services/USGSShadedReliefOnly/MapServer/tile/{z}/{y}/{x}")
// http://basemap.nationalmap.gov/arcgis/rest/services/USGSShadedReliefOnly/MapServer
//super.init(urlTemplate: "http://basemap.nationalmap.gov/arcgis/rest/services/USGSHydroNHD/MapServer/tile/{z}/{y}/{x}")
//super.init(urlTemplate: "http://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}")
//super.init(urlTemplate: "http://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryTopo/MapServer/tile/{z}/{y}/{x}")
//super.init(urlTemplate: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}")
//super.init(urlTemplate: "https://services.nationalmap.gov/arcgis/rest/services/USGSImageOnlyLarge/MapServer/tile/{z}/{y}/{x}")
//                       https://services.nationalmap.gov/arcgis/rest/services/USGSImageOnlyLarge/MapServer

// http://isse.cr.usgs.gov/arcgis/rest/services/Orthoimagery/USGS_EROS_Ortho_1Foot/ImageServer/exportImage?f=image&
// http://www.arcgis.com/home/webmap/viewer.html?url=http%3A%2F%2Fservices.nationalmap.gov%2Farcgis%2Frest%2Fservices%2FUSGSTopoLarge%2FMapServer&source=sd

// see also http://wiki.openstreetmap.org/wiki/USGS_High_Resolution_Orthoimagery#Transparency
// https://viewer.nationalmap.gov/help/HowTo.htm

/* from the NRL Stennis tile server http://geoint.nrlssc.navy.mil/TileServerClient/
http://geoint.nrlssc.navy.mil/geospatialData.php
NAIP, USGS DRG, Landsat, Digital Nautical Charts, Electronic Nautical Charts, Blue Marble, DTED, ETOPO.
FAA Sectionals, Terminal Area Charts, World Aeronautical Charts
*/

// http://seamlessrnc.nauticalcharts.noaa.gov/arcgis/services/RNC/NOAA_RNC/ImageServer/WMSServer
// http://seamlessrnc.nauticalcharts.noaa.gov/arcgis/rest/services/RNC/NOAA_RNC/MapServer
// http://www.nauticalcharts.noaa.gov/csdl/seamlessraster.html

// Landsat WMS links: http://wiki.openstreetmap.org/wiki/Landsat

/* building the tile address manually: https://blogs.esri.com/esri/arcgis/2008/01/31/deconstructing-the-map-cache-tiling-scheme-part-ii-working-with-map-caches-programmatically/
Map service tile handler

If the virtual directory is not exposed, you can still request a tile from the web server, but in this case you need to use the map service tile handler. Here’s an example of a URL for a tile retrieved by the map service tile handler:

http://serverx.esri.com/arcgis/services/dgaerials/MapServer?mapName=Layers&format=JPEG&level=0&row=671&column=640

Here is the breakdown of this URL:

http://serverx.esri.com/arcgis/services/dgaerials/MapServer: URL to the map service of the cache
mapName=Layers: Map name of the cached map service
format=JPEG: Image type of the cache
level=0: Level ID
row=671: Cache tile row in decimal format
column=640: Cache tile column in decimal format
*/

/* National Library of Scotland http://maps.nls.uk/projects/api/
http://nls-3.tileserver.com/nls/11/988/627.jpg
*/

// http://googlemapsmania.blogspot.com/2016/02/your-source-for-vintage-map-tiles.html

// https://esri.github.io/esri-leaflet/examples/tile-layer-1.html


/*		let Landsat7 = MapSourceDescription(identifier: .NRLLandsat7, name: "Landsat 7", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/Landsat7/{z}/{x}/{y}.jpg", cacheName: "Landsat7", cacheExtension: "jpg",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 19)

//http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/bluemarble/3/1/0.jpg
let Bluemarble = MapSourceDescription(identifier: .NRLBluemarble, name: "Blue Marble", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/bluemarble/{z}/{x}/{y}.jpg", cacheName: "bluemarble", cacheExtension: "jpg",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 11)

// http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/DTED0_GRID_COLOR1/3/1/0.jpg http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/DTED0_GRID_COLOR1/13/2047/1023.jpg
let DTED = MapSourceDescription(identifier: .NRLDTED, name: "DTED", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/DTED0_GRID_COLOR1/{z}/{x}/{y}.jpg", cacheName: "DTED", cacheExtension: "jpg",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 15)

// http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/ETOPO1_COLOR1/16/5246/3851.jpg
let ETOPO = MapSourceDescription(identifier: .NRLETOPO, name: "ETOPO", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/ETOPO1_COLOR1/{z}/{x}/{y}.jpg", cacheName: "ETOPO", cacheExtension: "jpg",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 16)

// http://geoint.nrlssc.navy.mil/dnc/wmts/DNC-WORLD/basemap/DNC-BASEMAP?SERVICE=openlayers&LAYER=DNC-BASEMAP&TILEMATRIX=13&TILEROW=481&TILECOL=655&FORMAT=image%2Fpng
let  DNC = MapSourceDescription(identifier: .NRLDNC, name: "DNC", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/dnc/wmts/DNC-WORLD/basemap/DNC-BASEMAP?SERVICE=openlayers&LAYER=DNC-BASEMAP&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&FORMAT=image%2Fpng", cacheName: "DNC", cacheExtension: "png",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 15)

// http://geoint.nrlssc.navy.mil/ENCServer/wmts/ENC/basemap/ENC-BASEMAP?SERVICE=openlayers&LAYER=ENC-BASEMAP&TILEMATRIX=11&TILEROW=120&TILECOL=163&FORMAT=image%2Fpng
let  ENC = MapSourceDescription(identifier: .NRLENC, name: "ENC", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/ENCServer/wmts/ENC/basemap/ENC-BASEMAP?SERVICE=openlayers&LAYER=ENC-BASEMAP&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&FORMAT=image%2Fpng", cacheName: "ENC", cacheExtension: "png",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 15)


// http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/FAASectionals/11/163/120.png
let sectionals = MapSourceDescription(identifier: .NRLFAASectionals, name: "FAA Sectionals", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/FAASectionals/{z}/{x}/{y}.png", cacheName: "FAA Sectionals", cacheExtension: "png",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 15)

// http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/FAAWorldAeronauticalCharts/10/81/60.png
let WACs = MapSourceDescription(identifier: .NRLFAAWAC, name: "FAA World Aeronautical Chart", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/nrltileserver/openlayers//{z}/{x}/{y}.jpg", cacheName: "", cacheExtension: "jpg",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 15)

// http://geoint.nrlssc.navy.mil/nrltileserver/openlayers/FAATerminalAreaChart/10/81/60.png
let TACs = MapSourceDescription(identifier: .NRLFAATAC, name: "FAA Terminal Area Chart", attribution: "NRL Stennis", isOpaque: true, appleMapType: standardUnderlayMapType, isAppleMap: false,
tileURLTemplate: "http://geoint.nrlssc.navy.mil/nrltileserver/openlayers//{z}/{x}/{y}.jpg", cacheName: "", cacheExtension: "jpg",
tileWidth: 512, tileHeight: 512, isGeometryFlipped: true, minimumZ: 0, maximumZ: 15)
*/

