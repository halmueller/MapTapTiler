# MapTapTiler

This package wraps up some functionality I've written over the years to help with putting map overlays 
onto `MKMapView` instances. It simplifies the setup of the overlays, and provides a tile cache.

Included are working samples for macOS, iOS, and tvOS, with about 10 different map tile servers demonstrated.

The overlays can come from [MapServer](https://mapserver.org), from Arc/Info, or any other server that provides tiles in the Google map 
tile format. I've included examples from USGS (topos and DOQs), two Open Street Map 
projects (Open Rail Map and Open Sea Map), 
several samples from [Stamen Design](http://maps.stamen.com/#watercolor/12/37.7706/-122.3782) 
(beautiful custom renders of OSM data), 
NOAA (raster nautical charts), [GEBCO world
ocean bathymetry](https://www.gebco.net), and [MapWarper](https://mapwarper.net) (which can rectify and then server any historical map you upload).

[OtherSources.md](Tiler%20Example/OtherSources.md) has dozens more sources that I haven't verified lately.

See any of the view controllers in the three sample apps to get started. The gist of it is:

- Create an instance of `MKMapView`, programmatically or in a storyboard.
- Make sure the mapview's delegate has been set to be your view controller or other owning object.
- Define a `MapSourceDescription` pointing to your desired tilesource.
- Call `ExternalTileOverlay(sourceDescription: <myMapSourceDescription>)`
- Call `MKTileOverlayRenderer(overlay: <myExternalTileOveerlay>)` and add that renderer to your mapview.
- Implement `mapView(:rendererFor:)` in your mapview's delegate. Don't forget to connect the delegate outlet.
- If your tile server uses HTTP, add an App Transport Security exemption for that server.


