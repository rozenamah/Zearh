import UIKit

protocol ChangePasswordPresentationLogic {
    func presentError(_ error: ChangePasswordPresenter.ChangePasswordError)
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
            }
        }
    }
    
    func presentError(_ error: ChangePasswordPresenter.ChangePasswordError) {
        switch error {
        case .currentPasswordToShort:
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
