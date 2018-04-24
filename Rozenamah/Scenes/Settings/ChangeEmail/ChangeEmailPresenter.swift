import UIKit

protocol ChangeEmailPresentationLogic {
    func handleError(_ error: RMError)
    func emailChangedSuccessful()
    func presentError(_ error: ChangeEmailPresenter.ChangeEmailError)
}

class ChangeEmailPresenter: ChangeEmailPresentationLogic {
	weak var viewController: ChangeEmailDisplayLogic?

	// MARK: Presentation logic
    
    enum ChangeEmailError: LocalizedError {
        case emailAlreadyTaken
        case incorrectEmail
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .emailAlreadyTaken:
                return "session.patient.error.emailTaken".localized
            case .incorrectEmail:
                return "settings.changeEmail.incorrectEmail".localized 
            case .unknownError:
                return "generic.error.unknown".localized
            }
        }
    }
    
    func emailChangedSuccessful() {
        viewController?.emailChangedSuccessful()
    }
    
    func handleError(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .duplicate:
            presentError(.emailAlreadyTaken)
        default:
            presentError(.unknownError)
        }
    }
    
    func presentError(_ error: ChangeEmailPresenter.ChangeEmailError) {
        switch error {
        case .emailAlreadyTaken, .incorrectEmail:
            viewController?.displayError(error)
        case .unknownError:
            viewController?.displayError(error)
        }
    }
}
