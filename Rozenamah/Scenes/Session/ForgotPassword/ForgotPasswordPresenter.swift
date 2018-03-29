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
                return "Email is incorrect"
            case .emailIsNotConnected:
                return "Email is not connected to any user"
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
                }
                return "Unknown error"
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
