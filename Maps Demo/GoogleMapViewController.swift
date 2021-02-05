//
//  GoogleMapViewController.swift
//  Maps Demo
//
//  Created by paw on 04.02.2021.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {

    @IBOutlet weak var map: GMSMapView!
    @IBAction func zoomAction(_ sender: Any) {
        zoomMap(action: .zoom)
    }
    @IBAction func unzoomAction(_ sender: Any) {
        zoomMap(action: .unzoom)
    }
    @IBAction func centerAction(_ sender: Any) {
        zoomMap(action: .centerize)
    }
    let maxMapZoom: Float = 21
    let minMapZoom: Float = 1
    var initialZoom: Float = 0
    
    
    var mapZoom: Float = 6.0
    

    var currentLocation: CLLocationCoordinate2D? = nil
    private let places: [Place] = [Place(coordinate: CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444), title: "HONOLULU", icon: UIImage(named: "1"), subtitle: "what?!?!"),
                                   Place(coordinate: CLLocationCoordinate2D(latitude: 55.752026118304435, longitude: 37.617478246957525), title: "OCEAN", icon: UIImage(named: "2"), subtitle: "it's Finder!!!")]

    override func viewDidLoad() {
        super.viewDidLoad()
        initialZoom = mapZoom
        map.delegate = self
        let camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: 0, longitude: 0), zoom: mapZoom)

        for place in places {
            addMarker(location: place.coordinate, title: place.title!, snippet: place.subtitle, icon: place.image!)
        }
//        addMarker(location: sydneyLocation, title: "Sydney", snippet: "Australia")
//        addMarker(location: cremleLocation, title: "Kremlin", snippet: "Capital city of Russia: Moscow")
        map.camera = camera
        map.setMinZoom(minMapZoom, maxZoom: maxMapZoom)
        let ln = LocationManager.shared
        ln.requestAccess { [unowned self] (isSuccess) in
            if isSuccess{
                ln.getLocation { [unowned self] (location) in
                    print(location as Any)
                    currentLocation = location
                }
            }
            map.isMyLocationEnabled = isSuccess

        }
    }
    

    
    func addMarker(location: CLLocationCoordinate2D, title: String, snippet: String? = nil, icon: UIImage? = nil){
        let marker = GMSMarker()
        marker.position = location
        marker.map = map
        marker.title = title
        marker.snippet = snippet
        marker.icon = icon
    }
    func updateMapZooming(){
        map.animate(toZoom: mapZoom)
    }
    func updateMapLocation(with location: CLLocationCoordinate2D) {
        map.animate(toLocation: location)
    }
    func zoomMap(action: ZoomAction){
        switch action {
        case .centerize:
            mapZoom = initialZoom
            if let location = currentLocation{
                updateMapLocation(with: location)
                updateMapZooming()
            }else{
                showError(errorMessage: "Cannot find your location! Try to enable permission")
            }
        case .zoom:
            if mapZoom + 0.5 < maxMapZoom{
                mapZoom += 0.5
                updateMapZooming()
            }
        case .unzoom:
            if mapZoom - 0.5 > minMapZoom{
                mapZoom -= 0.5
                updateMapZooming()
            }
        }
        
    }
    
}
    
 

extension GoogleMapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.title as Any)
        return true
    }
}
