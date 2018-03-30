import UIKit

protocol MainDoctorPresentationLogic: MainScreenPresentationLogic {
}

class MainDoctorPresenter: MainScreenPresenter, MainDoctorPresentationLogic {
	weak var viewController: MainDoctorDisplayLogic?
    override var baseViewController: MainScreenDisplayLogic? {
        return viewController
    }

	// MARK: Presentation logic
	
}
