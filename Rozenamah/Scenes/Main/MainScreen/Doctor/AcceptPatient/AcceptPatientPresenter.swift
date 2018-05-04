import UIKit

protocol AcceptPatientPresentationLogic {
    func patientAccepted(with booking: Booking?)
    func patienRejected()
    func handleError(_ error: RMError)
}

class AcceptPatientPresenter: AcceptPatientPresentationLogic {
	weak var viewController: AcceptPatientDisplayLogic?

	// MARK: Presentation logic
    
    
    func patientAccepted(with booking: Booking?) {
        viewController?.patientAccepted(with: booking)
    }
    
    func patienRejected() {
        viewController?.patientRejected()
    }
    
    func handleError(_ error: RMError) {
        viewController?.handle(error: error)
    }
	
}
