import UIKit

protocol ForgotPasswordPresentationLogic {
    func handleError(_ error: RMError) 
    func presentError(_ error: ForgotPasswordPresenter.ResetPasswordError)
    func presentResetSuccess()
}

class ForgotPasswordPresenter: ForgotPasswordPresentationLogic {
	weak var viewController: ForgotPasswordDisplayLogic?

    enum ResetPasswordError: LocalizedError {
        case incorrectEmail
        case emailIsNotConnected
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .incorrectEmail:
                return "session.login.error.incorrectEmail".localized
            case .emailIsNotConnected:
                return "session.resetPassword.emailNotConnected".localized
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription.localizedError ?? error.localizedDescription
                }
                return "generic.error.unknown".localized
            }
        }
    }
    
	// MARK: Presentation logic
    
    func handleError(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .notFound:
            presentError(.emailIsNotConnected)
        default:
            presentError(.unknown(error))
        }
    }
    
    func presentResetSuccess() {
        viewController?.resetPasswordSuccess()
    }
    
    func presentError(_ error: ForgotPasswordPresenter.ResetPasswordError) {
        switch error {
        case .incorrectEmail, .emailIsNotConnected:
            viewController?.handle(error: error, inField: .email)
        default:
            viewController?.handle(error: error)
        }
    }
}
