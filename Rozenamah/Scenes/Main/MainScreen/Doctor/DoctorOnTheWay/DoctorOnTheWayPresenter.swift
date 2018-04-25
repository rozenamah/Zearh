import UIKit

protocol DoctorOnTheWayPresentationLogic {
    func handle(_ error: Error)
    func doctorArrived()
    func doctorCancelled()
    
}

class DoctorOnTheWayPresenter: DoctorOnTheWayPresentationLogic {
	weak var viewController: DoctorOnTheWayDisplayLogic?

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
