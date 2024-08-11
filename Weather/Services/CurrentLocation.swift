import Foundation
import CoreLocation
import Combine

class CurrentLocation: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let locationSubject = PassthroughSubject<CLLocationCoordinate2D, Error>()
    
    override init() {
        super.init()
        print("CurrentLocation initialized")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestCurrentLocation() -> AnyPublisher<CLLocationCoordinate2D, Error> {
        print("Requesting current location...")
        checkLocationAuthorizationStatus()
        return locationSubject.eraseToAnyPublisher()
    }
    
    private func checkLocationAuthorizationStatus() {
        let status = locationManager.authorizationStatus
        print("Authorization status: \(status.rawValue)")
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied or restricted")
            locationSubject.send(completion: .failure(NSError(domain: "LocationAccessDenied", code: 1, userInfo: nil)))
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access authorized")
            locationManager.startUpdatingLocation()
        @unknown default:
            locationSubject.send(completion: .failure(NSError(domain: "UnknownAuthorizationStatus", code: 2, userInfo: nil)))
        }
    }
    
    // CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("locationManager didUpdateLocations: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            locationSubject.send(location.coordinate)
            locationManager.stopUpdatingLocation()
        } else {
            print("locationManager didUpdateLocations but no valid location found")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError: \(error.localizedDescription)")
        locationSubject.send(completion: .failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization called")
        checkLocationAuthorizationStatus()
    }
}
