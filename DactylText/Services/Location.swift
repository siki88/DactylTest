//
//  Location.swift
//  DactylText
//
//  Created by Lukáš Spurný on 16/08/2020.
//  Copyright © 2020 cz.sikisoft.DactylText. All rights reserved.
//

import Foundation
import CoreLocation

final class Location: NSObject, CLLocationManagerDelegate {

    // MARK: - Class properties
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Instance properties
    
    private var latitude: String?
    private var longitude: String?
    private var accuracy: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
    /*
    func setupLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        debugPrint("location start")
    }
    
    func locationRequest() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    */
    func getLatitude() -> String? {
        return latitude
    }
    
    func getLongitude() -> String? {
        return longitude
    }
    
    func getAccuracy() -> String? {
        return accuracy
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        latitude = String(location.coordinate.latitude)
        longitude = String(location.coordinate.longitude)
        accuracy = String(location.horizontalAccuracy)
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            return
        }
    }
}
