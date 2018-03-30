import UIKit

protocol MainDoctorBusinessLogic: MainScreenBusinessLogic {
}

class MainDoctorInteractor: MainScreenInteractor, MainDoctorBusinessLogic {
	var presenter: MainDoctorPresentationLogic?
	var worker = MainDoctorWorker()

	// MARK: Business logic
	
}
