import UIKit

protocol ChangeEmailPresentationLogic {
    func handleError(_ error: RMError)
    func emailIsUnique()
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
                return "Email is already taken"
            case .incorrectEmail:
                return "Email is incorrect"
            case .unknownError:
                return "Unknown error"
            }
        }
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
    
    func emailIsUnique() {
        viewController?.displayEmailIsUnique()
    }
}
