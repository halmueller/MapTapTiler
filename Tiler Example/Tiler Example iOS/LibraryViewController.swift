//
//  LibraryViewController.swift
//  Tiler Example
//
//  Created by Hal Mueller on 4/10/22.
//

import UIKit
import MapKit
import MapTapTiler

class LibraryViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPicker: UISegmentedControl!
    
    var overlay: ExternalTileOverlay!
    var renderer: MKTileOverlayRenderer!

    let mapChoices: [MapSourceDescription] = {

        // Note these two use HTTP, not HTTPS. App Transport Security exception domain entry required in Info.plist.
        let stamenTonerLite = MapSourceDescription(name: "Stamen Toner Lite", attribution: "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL. Stamen Design rendering of OpenStreetMap data", isOpaque: true, appleMapType: .satellite, isAppleMap: false,
                                               tileURLTemplate: "http://tile.stamen.com/toner-lite/{z}/{x}/{y}.png", cacheName: "StamenTonerLite", cacheExtension: "png",
                                               tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 18, maximumOverzoomZ: 20)
        
        let stamenWatercolor = MapSourceDescription(name: "Stamen Watercolor", attribution: "Map tiles by Stamen Design, under CC BY 3.0. Data by OpenStreetMap, under ODbL. Stamen Design rendering of OpenStreetMap data", isOpaque: true, appleMapType: .satellite, isAppleMap: false,
                                               tileURLTemplate: "http://tile.stamen.com/watercolor/{z}/{x}/{y}.png", cacheName: "StamenWatercolor", cacheExtension: "png",
                                               tileWidth: 256, tileHeight: 256, isGeometryFlipped: false, minimumZ: 0, maximumServerZ: 18, maximumOverzoomZ: 20)
        
        let openRailMap = MapSourceDescription(name: "Open Railway Map",
                                                   attribution: "Open Railway Map",
                                                   isOpaque: false,
                                                   appleMapType: .mutedStandard,
                                                   isAppleMap: false,
                                                   tileURLTemplate: "https://c.tiles.openrailwaymap.org/standard/{z}/{x}/{y}.png", cacheName: "openRailwayMap", cacheExtension: "png",
                                                   tileWidth: 512, tileHeight: 512, isGeometryFlipped: false, minimumZ: 3,
                                                   maximumServerZ: 16, maximumOverzoomZ: 20)

        let openSeaMap = MapSourceDescription(name: "Open Sea Map", attribution: "Open Sea Map",
                                              isOpaque: false, appleMapType: .satellite, isAppleMap: false,
                                              tileURLTemplate: "https://tiles.openseamap.org/seamark/{z}/{x}/{y}.png", cacheName: "openSeaMap", cacheExtension: "png",
                                              tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 18, maximumOverzoomZ: 20)
        
        // https://tileservice.charts.noaa.gov/tiles/50000_1/8/41/88.png
        let RNCs = MapSourceDescription(name: "NOAA Raster Nautical Chart", attribution: "NOAA", isOpaque: true, appleMapType: .satellite, isAppleMap: false,
                                        tileURLTemplate: "https://tileservice.charts.noaa.gov/tiles/50000_1/{z}/{x}/{y}.png", cacheName: "NOAARNC", cacheExtension: "png",
                                        tileWidth: 256, tileHeight: 256, isGeometryFlipped: true, minimumZ: 3, maximumServerZ: 16, maximumOverzoomZ: 20)
        
        let mapChoices = [
                          stamenTonerLite,
                          stamenWatercolor,
                          openRailMap,
                          openSeaMap,
                          RNCs,
        ]
        
        return mapChoices
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        self.mapView.mapType = .mutedStandard

        // no need for these, they won't be visible
        self.mapView.pointOfInterestFilter = .excludingAll

        configureMapOverlay(0)
    }
    
    func configureMapOverlay(_ index: Int) {
        
        mapView.removeOverlays(mapView.overlays)
        
        let mapDescription = mapChoices[index]
        
        overlay = ExternalTileOverlay(sourceDescription: mapDescription)
        renderer = MKTileOverlayRenderer(overlay: overlay)
        mapView.addOverlay(overlay, level: MKOverlayLevel.aboveLabels)
        mapView.mapType = mapDescription.appleMapType

    }

    @IBAction func pickedMap(_ sender: UISegmentedControl) {
        configureMapOverlay(sender.selectedSegmentIndex)
    }

}

extension LibraryViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return renderer
    }
    
}

