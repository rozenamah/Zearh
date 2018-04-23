import UIKit

protocol AcceptPatientPresentationLogic {
    func patientAccepted()
    func patienRejected()
    func handleError(_ error: RMError)
}

class AcceptPatientPresenter: AcceptPatientPresentationLogic {
	weak var viewController: AcceptPatientDisplayLogic?

	// MARK: Presentation logic
    
    
    func patientAccepted() {
        viewController?.patientAccepted(with: "121321321")
    }
    
    func patienRejected() {
        viewController?.patientRejected()
    }
    
    func handleError(_ error: RMError) {
        viewController?.handle(error: error)
    }
	
}
