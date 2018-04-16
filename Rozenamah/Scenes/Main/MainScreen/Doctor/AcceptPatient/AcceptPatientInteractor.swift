import UIKit

protocol AcceptPatientBusinessLogic {
}

class AcceptPatientInteractor: AcceptPatientBusinessLogic {
	var presenter: AcceptPatientPresentationLogic?
	var worker = AcceptPatientWorker()

	// MARK: Business logic
	
}
