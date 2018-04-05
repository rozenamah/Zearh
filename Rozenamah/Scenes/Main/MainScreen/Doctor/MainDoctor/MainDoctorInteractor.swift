import UIKit

protocol MainDoctorBusinessLogic: MainScreenBusinessLogic {
}

class MainDoctorInteractor: MainScreenInteractor, MainDoctorBusinessLogic {
	var presenter: MainDoctorPresentationLogic?
	var worker = MainDoctorWorker()
    override var basePresenter: MainScreenPresenter? {
        return presenter as? MainScreenPresenter
    }

	// MARK: Business logic
	
}
