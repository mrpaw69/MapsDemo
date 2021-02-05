//
//  AppleMapViewController.swift
//  Maps Demo
//
//  Created by paw on 04.02.2021.
//

import UIKit
import MapKit

class AppleMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func zoomAction(_ sender: Any) {
        zoom(with: .zoom)
    }
    
    @IBAction func unzoomAction(_ sender: Any) {
        zoom(with: .unzoom)
    }
    
    @IBAction func centerAction(_ sender: Any) {
        zoom(with: .centerize)
    }
    
    
    var location: CLLocationCoordinate2D {return  mapView.camera.centerCoordinate}
    var regionRadius: CLLocationDistance = 50000
    var region: MKCoordinateRegion {MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)}
    
    private let places: [Place] = [Place(coordinate: CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444), title: "HONOLULU", icon: UIImage(named: "1"), subtitle: "what?!?!"),
                                   Place(coordinate: CLLocationCoordinate2D(latitude: 55.752026118304435, longitude: 37.617478246957525), title: "OCEAN", icon: UIImage(named: "2"), subtitle: "it's Finder!!!")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addAnnotations(places)
        mapView.showsUserLocation = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var region = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        let ln = LocationManager.shared
        ln.requestAccess { (isSuccess) in
            if isSuccess{
                ln.getLocation { (location) in
                    print(location as Any)
                    if let location = location{
                    region.center = location
                    }
                }
            }
        }
//        let location = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
//        let regionRadius: CLLocationDistance = 50000
        mapView.setRegion(region, animated: true) // фокус для карты
    }
    
    func updateMap(){
        mapView.setRegion(region, animated: true)
    }
    
    func zoom(with action: ZoomAction){
        switch action {
        case .centerize:
            let ln = LocationManager.shared
            ln.requestAccess { [unowned self] (isSuccess) in
                if isSuccess{
                    ln.getLocation {(loc) in
                        if let loc = loc{
                            regionRadius = 200
                            mapView.setRegion(MKCoordinateRegion.init(center: loc, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius), animated: true)
                        }else{
                            showError(errorMessage: "Failed to get your location")
                        }
                    }
                }else{
                    showError(errorMessage: "Failed to get your location")
                }
            }
        case .zoom:
            if regionRadius >= 50 {
                regionRadius /= 2
            }
            updateMap()
        case .unzoom:
            if regionRadius < 12800000 {
                regionRadius *= 2
            }
             updateMap()
        }
    }
}


@objc
class Place: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    lazy var tapReactionClosure = { [weak self] in print(self?.title as Any) }
    @objc func tapped(){
        tapReactionClosure()
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String?, icon: UIImage?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.image = icon
        self.subtitle = subtitle
    }
}


// функция аннотаций для отображения
extension AppleMapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        let myAnnotation = annotation as! Place
        
        let  annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        annotationView.image = myAnnotation.image
        let gestureRecognizer = UITapGestureRecognizer(target: myAnnotation, action: #selector(myAnnotation.tapped))
        annotationView.addGestureRecognizer(gestureRecognizer)
        annotationView.canShowCallout = true
        return annotationView
    }
}
