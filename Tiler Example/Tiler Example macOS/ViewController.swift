//
//  ViewController.swift
//  Tiler Example macOS
//
//  Created by Hal Mueller on 4/24/22.
//

import Cocoa
import MapKit
import MapTapTiler

class ViewController: NSViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var gebcoBasemapOverlay: ExternalTileOverlay!
    let gebcoBasemap = MapSourceDescription(name: "GEBCO Basemap", attribution: "A color shaded relief visualization of the General Bathymetric Chart of the Oceans (GEBCO) GEBCO_2021 global land and seafloor elevation dataset.",
                                            isOpaque: true, appleMapType: .satellite, isAppleMap: false,
                                            tileURLTemplate:  "https://tiles.arcgis.com/tiles/C8EMgrsFcRFL6LrL/arcgis/rest/services/GEBCO_basemap_NCEI/MapServer/tile/{z}/{y}/{x}?cacheKey=8976bf93c07c8d55",
                                            cacheName: "GEBCObasemap", cacheExtension: "png",
                                            tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 26, maximumOverzoomZ: 26)
    // WMST description: https://tiles.arcgis.com/tiles/C8EMgrsFcRFL6LrL/arcgis/rest/services/GEBCO_basemap_NCEI/MapServer?cacheKey=8976bf93c07c8d55
    // contours: https://tiles.arcgis.com/tiles/C8EMgrsFcRFL6LrL/arcgis/rest/services/GEBCO_contours/MapServer/tile/{z}/{y}/{x}?cacheKey=9794ce4c527468ba
    // with WMST description at https://tiles.arcgis.com/tiles/C8EMgrsFcRFL6LrL/arcgis/rest/services/GEBCO_contours/MapServer?cacheKey=9794ce4c527468ba
    var gebcoBasemapTileRenderer: MKTileOverlayRenderer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // have to have _something_
        self.mapView.mapType = gebcoBasemap.appleMapType
        
        // could turn these on, or not
        self.mapView.pointOfInterestFilter = .excludingAll
        
        gebcoBasemapOverlay = ExternalTileOverlay(sourceDescription: gebcoBasemap)
        gebcoBasemapTileRenderer = MKTileOverlayRenderer(overlay: gebcoBasemapOverlay)
        mapView.addOverlay(gebcoBasemapOverlay, level: MKOverlayLevel.aboveLabels)
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay === gebcoBasemapOverlay {
            return gebcoBasemapTileRenderer
        }
        assert(false, "shouldn't be here")
        return MKOverlayRenderer()
    }
    
}


