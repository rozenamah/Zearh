import UIKit
import CoreLocation

protocol DoctorLocationPresentationLogic {
    func visitCancelled()
    func updateDoctorLocation(_ location: CLLocation)
    func handle(_ error: Error)
}

class DoctorLocationPresenter: DoctorLocationPresentationLogic {
	weak var viewController: DoctorLocationDisplayLogic?

	// MARK: Presentation logic
    
    func visitCancelled() {
        viewController?.visitCancelled()
    }
    
    func updateDoctorLocation(_ location: CLLocation) {
        viewController?.updateDoctorLocation(location)
    }
    
    func handle(_ error: Error) {
        viewController?.presentError(error)
    }
	
}
