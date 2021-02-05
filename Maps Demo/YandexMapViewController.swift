//
//  YandexMapViewController.swift
//  Maps Demo
//
//  Created by paw on 05.02.2021.
//

import UIKit
import ObjectiveC
import YandexMapsMobile

class YandexMapViewController: UIViewController {
    var currentCamera: YMKCameraPosition {map.mapWindow.map.cameraPosition}
    var currentAzimuth: Float {currentCamera.azimuth}
    var currentTilt: Float {currentCamera.tilt}
    var zoom: Float = 6
    
    var placesCollection: YMKClusterizedPlacemarkCollection?
    private let places: [YMPlace] = [YMPlace(coordinate: YMKPoint(latitude: 21.282778, longitude: -157.829444), title: "HONOLULU", icon: UIImage(named: "1"), subtitle: "what?!?!"),
                                   YMPlace(coordinate: YMKPoint(latitude: 55.752026118304435, longitude: 37.617478246957525), title: "OCEAN", icon: UIImage(named: "2"), subtitle: "it's Finder!!!")]
    
    @IBOutlet weak var map: YMKMapView!
    
    @IBAction func zoomAction(_ sender: Any) {
        zoom(with: .zoom)
    }
    
    @IBAction func unzoomAction(_ sender: Any) {
        zoom(with: .unzoom)
    }
    @IBAction func centerAction(_ sender: Any) {
        zoom(with: .centerize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.mapWindow.map.move(
                with: YMKCameraPosition.init(target: YMKPoint(latitude: 0, longitude: 0), zoom: zoom, azimuth: 0, tilt: 0),
                animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
                cameraCallback: nil)
        for place in places {createMarker(with: place)}
    }
    func createMarker(with place: YMPlace){
        let placemark = map.mapWindow.map.mapObjects.addPlacemark(with: place.coordinate, image: place.image!, style: YMKIconStyle())
        placemark.place = place
        placemark.addTapListener(with: self)
    }
    func updateMapZoom() {
        map.mapWindow.map.move(
            with: YMKCameraPosition.init(target: currentCamera.target, zoom: zoom, azimuth: currentAzimuth, tilt: currentTilt),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 0.5),
            cameraCallback: nil)
    }
    func zoom(with action: ZoomAction){
        switch action{
        case .centerize:
            break
        case .zoom:
            if zoom + 1 <= 21 {
                zoom += 1
            }
            updateMapZoom()
        case .unzoom:
            if zoom - 1 >= 1 {
                zoom -= 1
            }
            updateMapZoom()
        }
    }
    
    

    
    
    
}

class YMPlace{//}: YMKMapObject{
    var coordinate: YMKPoint
    var title: String?
    var subtitle: String?
    var image: UIImage?
    
    init(coordinate: YMKPoint, title: String?, icon: UIImage?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.image = icon
        self.subtitle = subtitle
    }
}

extension YandexMapViewController: YMKClusterListener, YMKMapObjectTapListener{
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        print(mapObject.place.title as Any)
        return true
    }

    
    func onClusterAdded(with cluster: YMKCluster) {
//        cluster.appearance.setIconWith(clusterImage(cluster.size))
    }
    
    
}
private var assosiatedObject: UInt64 = 0
extension YMKMapObject{
    var place: YMPlace{
        get{objc_getAssociatedObject(self, &assosiatedObject) as! YMPlace}
        set{objc_setAssociatedObject(self, &assosiatedObject, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
}
