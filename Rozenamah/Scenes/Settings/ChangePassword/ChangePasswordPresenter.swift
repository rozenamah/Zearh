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
                return "session.login.error.passwordTooShort".localized
            case .newPasswordToLong:
                return "session.login.error.passwordTooLong".localized
            case .passwordsDontMatch:
                return "session.patient.error.diffrentPasswords".localized
            case .currentPasswordToShort:
                return "session.login.error.passwordTooShort".localized
            case .incorrectPassword:
                return "session.patient.error.incorrectPassword".localized
            case .oldPasswordIncorrect:
                return "session.patient.error.incorrectPassword".localized
            case .unknownError:
                return "generic.error.unknown".localized
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
