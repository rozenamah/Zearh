import UIKit
import CoreLocation

protocol DoctorLocationPresentationLogic {
    func visitCancelled()
    func updateDoctorLocation(_ location: CLLocation)
    func handle(_ error: RMError)
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
    
    func handle(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .badRequest:
            // Propably booking changed it's state, skip this error
            break
        default:
            viewController?.presentError(error)
        }
    }
	
}
