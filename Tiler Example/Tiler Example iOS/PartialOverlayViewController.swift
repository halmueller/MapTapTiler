//
//  PartialOverlayViewController.swift
//  Tiler Example
//
//  Created by Hal Mueller on 4/11/22.
//

import UIKit
import MapKit
import MapTapTiler

class PartialOverlayViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var overlay: ExternalTileOverlay!

    // https://c.tiles.openrailwaymap.org/standard/19/83892/182927.png
    let openRailMap = MapSourceDescription(name: "Open Railway Map",
                                               attribution: "Open Railway Map",
                                               isOpaque: false,
                                               appleMapType: MKMapType.mutedStandard,
                                               isAppleMap: false,
                                               tileURLTemplate: "https://c.tiles.openrailwaymap.org/standard/{z}/{x}/{y}.png", cacheName: "openRailwayMap", cacheExtension: "png",
                                               tileWidth: 512, tileHeight: 512, isGeometryFlipped: false, minimumZ: 3,
                                               maximumServerZ: 20, maximumOverzoomZ: 20)
    var solidBasemapTileRenderer: MKTileOverlayRenderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSolidBasemap()
    }
    
    func configureSolidBasemap() {
        // have to have _something_
        self.mapView.mapType = openRailMap.appleMapType
        
        // could turn these on, or not
        self.mapView.pointOfInterestFilter = .excludingAll
        
        overlay = ExternalTileOverlay(sourceDescription: openRailMap)
        solidBasemapTileRenderer = MKTileOverlayRenderer(overlay: overlay!)
        mapView.addOverlay(overlay!, level: MKOverlayLevel.aboveLabels)
    }
}

extension PartialOverlayViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return solidBasemapTileRenderer!
    }
    
}

