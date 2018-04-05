import UIKit

protocol EditProfilePresentationLogic {
    func profileUpdated()
    func handleError(_ error: RMError)
}

class EditProfilePresenter: EditProfilePresentationLogic {
	weak var viewController: EditProfileDisplayLogic?

	// MARK: Presentation logic
    
    func handleError(_ error: RMError) {
        switch error {
        default:
            viewController?.displayError()
        }
    }
    
    func profileUpdated() {
        viewController?.profileUpdatedSuccessful()
    }
}
