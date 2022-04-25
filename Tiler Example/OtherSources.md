Overzoom mode: https://stackoverflow.com/q/4417545/719690

 Other possible tileservers:
 
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

Lots of servers listed at https://tiles.arcgis.com/tiles/C8EMgrsFcRFL6LrL/arcgis/rest/services?f=html&cacheKey=9794ce4c527468ba

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

