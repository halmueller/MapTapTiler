//
//  ScaleSensitiveViewController.swift
//  Tiler Example
//
//  Created by Hal Mueller on 4/11/22.
//

import UIKit
import MapKit
import MapTapTiler

class DoubleOverlayViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var railOverlay: ExternalTileOverlay? = nil
    var stamenTerrainBasemapOverlay: ExternalTileOverlay? = nil

    let openRailMap = MapSourceDescription(name: "Open Railway Map",
                                               attribution: "Open Railway Map",
                                               isOpaque: false,
                                               appleMapType: MKMapType.mutedStandard,
                                               isAppleMap: false,
                                               tileURLTemplate: "https://c.tiles.openrailwaymap.org/standard/{z}/{x}/{y}.png", cacheName: "openRailwayMap", cacheExtension: "png",
                                               tileWidth: 512, tileHeight: 512, isGeometryFlipped: false, minimumZ: 3,
                                               maximumServerZ: 16, maximumOverzoomZ: 20)
    let stamenTerrain = MapSourceDescription(name: "Stamen Watercolor", attribution: "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL. Stamen Design rendering of OpenStreetMap data", isOpaque: true, appleMapType: .satellite, isAppleMap: false,
                                           tileURLTemplate: "http://tile.stamen.com/terrain-background/{z}/{x}/{y}.png", cacheName: "StamenTerrainBackground", cacheExtension: "png",
                                           tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 18, maximumOverzoomZ: 20)
    let stamenTonerLite = MapSourceDescription(name: "Stamen Toner Lite", attribution: "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL. Stamen Design rendering of OpenStreetMap data", isOpaque: true, appleMapType: .satellite, isAppleMap: false,
                                           tileURLTemplate: "http://tile.stamen.com/toner-lite/{z}/{x}/{y}.png", cacheName: "StamenTonerLite", cacheExtension: "png",
                                           tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 18, maximumOverzoomZ: 20)
    var railOverlayTileRenderer: MKTileOverlayRenderer?
    var stamenBasemapTileRenderer: MKTileOverlayRenderer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // have to have _something_
        self.mapView.mapType = openRailMap.appleMapType
        
        // could turn these on, or not
        self.mapView.pointOfInterestFilter = .excludingAll
        
        stamenTerrainBasemapOverlay = ExternalTileOverlay(sourceDescription: stamenTonerLite)
        stamenBasemapTileRenderer = MKTileOverlayRenderer(overlay: stamenTerrainBasemapOverlay!)
        mapView.addOverlay(stamenTerrainBasemapOverlay!, level: MKOverlayLevel.aboveLabels)
        
        railOverlay = ExternalTileOverlay(sourceDescription: openRailMap)
        railOverlayTileRenderer = MKTileOverlayRenderer(overlay: railOverlay!)
        mapView.addOverlay(railOverlay!, level: MKOverlayLevel.aboveLabels)
    }
}

extension DoubleOverlayViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay === railOverlay {
            return railOverlayTileRenderer!
        } else if overlay === stamenTerrainBasemapOverlay {
            return stamenBasemapTileRenderer!
        }
        assert(false, "shouldn't be here")
        return MKOverlayRenderer()
    }
    
}

