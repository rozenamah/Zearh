import UIKit

protocol AcceptDoctorBusinessLogic {
}

class AcceptDoctorInteractor: AcceptDoctorBusinessLogic {
	var presenter: AcceptDoctorPresentationLogic?
	var worker = AcceptDoctorWorker()

	// MARK: Business logic
	
}
