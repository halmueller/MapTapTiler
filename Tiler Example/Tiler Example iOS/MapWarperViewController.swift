//
//  MapWarperViewController.swift
//  Tiler Example
//
//  Created by Hal Mueller on 4/11/22.
//

import UIKit
import MapKit
import MapTapTiler

class MapWarperViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var overlay: ExternalTileOverlay!
    var renderer: MKTileOverlayRenderer!
    let mapWarper = MapSourceDescription(name: "Kroll Seattle",
                                               attribution: "MapWarper",
                                               isOpaque: false,
                                               appleMapType: MKMapType.mutedStandard,
                                               isAppleMap: false,
//                                               tileURLTemplate: "https://mapwarper.net/maps/tile/34115/{z}/{x}/{y}",
//                                               cacheName: "MapWarperKrollSeattle",
//                                               tileURLTemplate: "https://mapwarper.net/maps/tile/61967/{z}/{x}/{y}",
//                                               cacheName: "MapWarperErieCanalRomeNY",
                                               tileURLTemplate: "https://mapwarper.net/maps/tile/62331/{z}/{x}/{y}",
                                               cacheName: "MapWarperID_MT_OR_WA_1891",
                                               cacheExtension: "png",
                                               tileWidth: 256,
                                               tileHeight: 256,
                                               isGeometryFlipped: false,
                                               minimumZ: 4,
                                               maximumServerZ: 16, maximumOverzoomZ: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSolidBasemap()
    }
    
    func configureSolidBasemap() {
        // have to have _something_
        self.mapView.mapType = mapWarper.appleMapType
        
        // no need for these, they won't be visible
        self.mapView.pointOfInterestFilter = .excludingAll
        
        overlay = ExternalTileOverlay(sourceDescription: mapWarper)
        renderer = MKTileOverlayRenderer(overlay: overlay)
        mapView.addOverlay(overlay, level: MKOverlayLevel.aboveLabels)
    }
}

extension MapWarperViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return renderer
    }

}
