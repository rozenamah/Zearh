import UIKit

protocol ChangePasswordPresentationLogic {
    func presentError(_ error: ChangePasswordPresenter.ChangePasswordError)
    func passwordChangedSuccessful()
    func handleError(_ error: RMError)
}

class ChangePasswordPresenter: ChangePasswordPresentationLogic {
	weak var viewController: ChangePasswordDisplayLogic?

	// MARK: Presentation logic
    
    enum ChangePasswordError: LocalizedError {
        case currentPasswordToShort
        case newPasswordToShort
        case newPasswordToLong
        case passwordsDontMatch
        case incorrectPassword
        case oldPasswordIncorrect
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .newPasswordToShort:
                return "Password must have at least 4 characters"
            case .newPasswordToLong:
                return "Password can have maximum 30 characters"
            case .passwordsDontMatch:
                return "Passwords are not the same"
            case .currentPasswordToShort:
                return "Password must have at least 4 characters"
            case .incorrectPassword:
                return "Password is incorrect"
            case .oldPasswordIncorrect:
                return "Password is incorrect"
            case .unknownError:
                return "Unknown error"
            }
        }
    }
    
    func passwordChangedSuccessful() {
        viewController?.passwordChangedSuccessful()
    }
    
    func handleError(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .unauthorized:
            presentError(.oldPasswordIncorrect)
        default:
            presentError(.unknownError)
        }
    }
    
    func presentError(_ error: ChangePasswordPresenter.ChangePasswordError) {
        switch error {
        case .currentPasswordToShort, .oldPasswordIncorrect, .unknownError:
            viewController?.handle(error: error, inField: .currentPassword)
        case .newPasswordToLong, .incorrectPassword:
            viewController?.handle(error: error, inField: .newPassword)
        case .newPasswordToShort:
            viewController?.handle(error: error, inField: .newPassword)
        case .passwordsDontMatch:
            viewController?.handle(error: error, inField: .confirmPassword)
        }
    }
}
