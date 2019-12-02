import UIKit

protocol DoctorOnTheWayPresentationLogic {
    func handle(_ error: Error)
    func doctorArrived(withBooking booking: Booking)
    func doctorCancelled()
    
}

class DoctorOnTheWayPresenter: DoctorOnTheWayPresentationLogic {
	weak var viewController: DoctorOnTheWayDisplayLogic?

	// MARK: Presentation logic
	
    func handle(_ error: Error) {
        viewController?.presentError(error)
    }
    
    func doctorArrived(withBooking booking: Booking) {
        viewController?.doctorArrived(withBooking: booking)
    }
    
    func doctorCancelled() {
        viewController?.doctorCancelled()
    }
    
}
