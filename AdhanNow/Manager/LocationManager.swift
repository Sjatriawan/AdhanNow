//
//  LocationManager.swift
//  AdhanNow
//
//  Created by M Yogi Satriawan on 10/03/24.
//

import Foundation
import CoreLocation
class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let manager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var locationError: Error?
    @Published var cityName: String = ""

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error
        print("Failed to get user location: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            locationError = NSError(domain: "Location Permission Denied", code: 1, userInfo: [NSLocalizedDescriptionKey: "User denied location permissions."])
        }
    }
}
