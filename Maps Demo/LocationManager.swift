//
//  LocationManager.swift
//  Geolocation
//
//  Created by Nik on 2/3/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject{
    static let shared = LocationManager()
    static var canRequestServuce: Bool {
        switch LocationManager.shared.locationManager.authorizationStatus {
                    case .authorizedAlways , .authorizedWhenInUse:
                        return true
                    case .notDetermined , .denied , .restricted:
                        return false
                    default:
                        return false
                }
    }

    typealias AccessRequestBlock = (Bool)-> ()
    typealias LocationRequestBlock = (CLLocationCoordinate2D?) -> ()
    
    var isEnabled: Bool { return CLLocationManager.isEnabled }
    var canRequestAccess: Bool { return LocationManager.canRequestServuce }
    
    private var accessRequestCompletion: AccessRequestBlock?
    private var locationRequestCompletion: LocationRequestBlock?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAccess( completion: AccessRequestBlock?) {
        accessRequestCompletion = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation (completion: LocationRequestBlock?){
        locationRequestCompletion = completion
        locationManager.startUpdatingLocation()
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        accessRequestCompletion?(isEnabled)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]){
        guard let location = manager.location?.coordinate else {return}
        locationRequestCompletion?(location)
        locationRequestCompletion = nil
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        manager.stopUpdatingLocation()
        locationRequestCompletion?(nil)
        locationRequestCompletion = nil
    }
}

extension CLLocationManager {
    
    static var isEnabled: Bool {
        //return authorizationStatus() == .authorizedAlways || authorizationStatus() == .authorizedWhenInUse
        return CLLocationManager.locationServicesEnabled()
    }
}

