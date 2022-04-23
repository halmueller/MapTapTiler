//
//  SingleOverlayViewController.swift
//  Tiler Example
//
//  Created by Hal Mueller on 4/11/22.
//

import UIKit
import MapKit
import MapTapTiler

class SolidOverlayViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var overlay: ExternalTileOverlay? = nil
    var solidBasemapTileRenderer: MKTileOverlayRenderer?
    let USGSImageryTopo = MapSourceDescription(name: "USGS Topo",
                                               attribution: "USGS",
                                               isOpaque: true,
                                               appleMapType: MKMapType.mutedStandard,
                                               isAppleMap: false,
                                               tileURLTemplate: "https://basemap.nationalmap.gov/arcgis/rest/services/USGSTopo/MapServer/tile/{z}/{y}/{x}",
                                               cacheName: "USGSTopo",
                                               cacheExtension: "png",
                                               tileWidth: 256,
                                               tileHeight: 256,
                                               isGeometryFlipped: false,
                                               minimumZ: 0,
                                               maximumServerZ: 16, maximumOverzoomZ: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSolidBasemap()
    }
    
    func configureSolidBasemap() {
        // have to have _something_
        self.mapView.mapType = USGSImageryTopo.appleMapType
        
        // no need for these, they won't be visible
        self.mapView.pointOfInterestFilter = .excludingAll
        
        overlay = ExternalTileOverlay(sourceDescription: USGSImageryTopo)
        solidBasemapTileRenderer = MKTileOverlayRenderer(overlay: overlay!)
        mapView.addOverlay(overlay!, level: MKOverlayLevel.aboveLabels)
    }
}

extension SolidOverlayViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return solidBasemapTileRenderer!
    }

}
