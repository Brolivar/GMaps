//
//  ViewController.swift
//  MOIA-Maps
//
//  Created by Jose Bolivar on 10/7/21.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    // MARK: - Properties
    //Ideally this should be injected by a third party entity (i.e navigator, segue manager, etc...)
    var markedLocationManager: MarkedLocationModelController! = MarkedLocationModelController()

    // Initial state of the map
    private let initialLongitude = 9.9839786
    private let initialLatitude = 53.5499242
    private let initialZoom: Float = 15

    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
  }

    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: self.initialLatitude, longitude: self.initialLongitude, zoom: self.initialZoom)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
    }

    private func requestSelectedLocationData(latitude: Double, longitude: Double) {

        // Display popup
        self.markedLocationManager.requestLocationData(latitude: latitude, longitude: longitude) { status in
            print("Request completed. Latitude: ", latitude, " longitude: ", longitude)
        }

    }
}

// MARK: - MapViewController GMSMapViewDelegate extension
extension MapViewController: GMSMapViewDelegate {

    // Handle the long press on map
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("pressed!")
        mapView.clear()
        let marker = GMSMarker(position: coordinate)
        marker.icon = UIImage(named: "MapLocationMarker")
        marker.map = mapView
        self.requestSelectedLocationData(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
