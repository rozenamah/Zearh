import UIKit

protocol MainDoctorPresentationLogic: MainScreenPresentationLogic {
    func handleError(_ error: RMError)
    func avabilityUpdatedTo(_ newAvaibility: Bool)
}

class MainDoctorPresenter: MainScreenPresenter, MainDoctorPresentationLogic {
	weak var viewController: MainDoctorDisplayLogic?
    override var baseViewController: MainScreenDisplayLogic? {
        return viewController
    }

	// MARK: Presentation logic
	
    func handleError(_ error: RMError) {
        viewController?.handle(error: error)
    }
    
    func avabilityUpdatedTo(_ newAvaibility: Bool) {
        if newAvaibility {
            viewController?.markAsWaitingForRequests()
        } else {
            viewController?.markAsRejectingRequests()
        }
    }
}
