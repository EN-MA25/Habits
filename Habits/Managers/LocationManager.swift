//
//  LocationManager.swift
//  Habits
//
//  Created by Erik on 2026-05-08.
//

import CoreLocation
import Observation

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation?, Never>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func requestCurrentLocation() async -> CLLocation? {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        continuation?.resume(returning: locations.last)
        continuation = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        continuation?.resume(returning: nil)
        continuation = nil
    }
}
