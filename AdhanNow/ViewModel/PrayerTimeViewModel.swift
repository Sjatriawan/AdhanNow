//
//  PrayerTimeViewModel.swift
//  AdhanNow
//
//  Created by M Yogi Satriawan on 10/03/24.
//

import Foundation
import CoreLocation

class PrayerTimeViewModel: NSObject, ObservableObject {
    @Published var prayerTimes: [PrayerTime] = []
    @Published var cityName: String = ""
    @Published var errorMessage: String?

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func fetchPrayerTimes() {
        guard let city = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), !city.isEmpty else {
            errorMessage = "Nama kota tidak boleh kosong"
            return
        }

        guard let url = URL(string: "http://api.aladhan.com/v1/timingsByCity?city=\(city)&country=Indonesia&method=2") else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                self.errorMessage = error?.localizedDescription ?? "Unknown error"
                return
            }

            do {
                let result = try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
                DispatchQueue.main.async {
                    self.prayerTimes = result.data.timings.map { PrayerTime(name: $0.key, time: $0.value) }
                    self.prayerTimes = self.prayerTimes.filter { $0.name != "Sunset" }
                    self.prayerTimes = self.prayerTimes.filter { $0.name != "Sunrise" }
                    self.prayerTimes = self.prayerTimes.filter { $0.name != "Firstthird" }
                    self.prayerTimes = self.prayerTimes.filter { $0.name != "Lastthird" }
                    self.prayerTimes = self.prayerTimes.filter { $0.name != "Midnight" }


                }
            } catch {
                self.errorMessage = "Failed to decode response: \(error)"
            }
        }.resume()
        
    }
}

// MARK: - CLLocationManagerDelegate

extension PrayerTimeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let city = placemarks?.first?.locality {
                self.cityName = city
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to get user location: \(error.localizedDescription)"
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            errorMessage = "User denied location permissions."
        }
    }
}
