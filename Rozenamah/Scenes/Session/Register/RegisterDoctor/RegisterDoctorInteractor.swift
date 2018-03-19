import UIKit

protocol RegisterDoctorBusinessLogic {
}

class RegisterDoctorInteractor: RegisterDoctorBusinessLogic {
	var presenter: RegisterDoctorPresentationLogic?
	var worker = RegisterDoctorWorker()

	// MARK: Business logic
	
}
