import UIKit
import CoreLocation

protocol BusyDoctorBusinessLogic {
    func updateDoctorsLocation(_ location: CLLocation)
}

class BusyDoctorInteractor: BusyDoctorBusinessLogic {
	var presenter: BusyDoctorPresentationLogic?
	var worker = BusyDoctorWorker()

	// MARK: Business logic
    
    func updateDoctorsLocation(_ location: CLLocation) {
        worker.updateLocationInDataBase(location)
    }
	
}
