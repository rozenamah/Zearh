import UIKit

protocol BusyDoctorPresentationLogic {
    func handle(_ error: Error)
    func doctorArrived()
    func doctorCancelled()
    
}

class BusyDoctorPresenter: BusyDoctorPresentationLogic {
	weak var viewController: BusyDoctorDisplayLogic?

	// MARK: Presentation logic
	
    func handle(_ error: Error) {
        viewController?.presentError(error)
    }
    
    func doctorArrived() {
        viewController?.doctorArrived()
    }
    
    func doctorCancelled() {
        viewController?.doctorCancelled()
    }
    
}
