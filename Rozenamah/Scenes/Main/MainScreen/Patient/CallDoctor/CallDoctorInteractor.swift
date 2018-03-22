import UIKit

protocol CallDoctorBusinessLogic {
}

class CallDoctorInteractor: CallDoctorBusinessLogic {
	var presenter: CallDoctorPresentationLogic?
	var worker = CallDoctorWorker()

	// MARK: Business logic
	
}
