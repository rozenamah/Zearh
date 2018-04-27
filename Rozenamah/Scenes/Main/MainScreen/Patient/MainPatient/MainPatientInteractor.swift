import UIKit
import CoreLocation
import GoogleMaps
import UserNotifications

protocol MainPatientBusinessLogic: MainScreenBusinessLogic {
    var currentLocation: CLLocation? { get }
}

class MainPatientInteractor: MainScreenInteractor, MainPatientBusinessLogic {
	var presenter: MainPatientPresentationLogic?
	var worker = MainPatientWorker()
    override var basePresenter: MainScreenPresenter? {
        return presenter as? MainScreenPresenter
    }
    
    /// Returns last location of user, we use it in search in order to fill it in search fitlers
    var currentLocation: CLLocation? {
        return locationManager.location
    }

	// MARK: Business logic
    
    override func firstLocationFetched() {
        // Location fetched, load nearby doctors on map
        if let location = locationManager.location {
            worker.fetchDoctors(nearby: location) { (doctorsLocations, error) in
                if let _ = error {
                    // If error - do nothing
                    return
                }
                if let locations = doctorsLocations {
                    self.presenter?.presentDoctorLocations(locations.map({ $0.toCLCoordinates }))
                }
            }
        }
    }
}
