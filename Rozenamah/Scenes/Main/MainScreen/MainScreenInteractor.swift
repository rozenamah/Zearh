import UIKit
import CoreLocation
import GoogleMaps

protocol MainScreenBusinessLogic {
    func returnToUserLocation()
}

class MainScreenInteractor: NSObject, MainScreenBusinessLogic {
	var presenter: MainScreenPresentationLogic?
	var worker = MainScreenWorker()

    private var locationManager = CLLocationManager()

    /// Whenever first location is found move camera to this position
    fileprivate var firstLocationDisplayed: Bool = false
    
	// MARK: Business logic
	
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func returnToUserLocation() {
        if let myLocation = locationManager.location {
            presenter?.moveCameraToPosition(location: myLocation)
        }
    }
    
    private func startCurrentObservingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopCurrentObservingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension MainScreenInteractor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startCurrentObservingLocation()
        case .denied, .restricted:
            // TODO: User can't user this app now
            break
        default:
            break
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if let firstLocation = locations.first, !firstLocationDisplayed {
            firstLocationDisplayed = true
            presenter?.moveCameraToPosition(location: firstLocation)
        }
    }
    
}
