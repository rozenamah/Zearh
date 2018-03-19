import UIKit

protocol ForgotPasswordPresentationLogic {
    func presentError(_ error: ForgotPasswordPresenter.ResetPasswordError)
    func presentResetSuccess()
}

class ForgotPasswordPresenter: ForgotPasswordPresentationLogic {
	weak var viewController: ForgotPasswordDisplayLogic?

    enum ResetPasswordError: LocalizedError {
        case incorrectEmail
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .incorrectEmail:
                return "Email is incorrect"
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
                }
                return "Unknown error"
            }
        }
    }
    
	// MARK: Presentation logic
    
    func presentResetSuccess() {
        viewController?.resetPasswordSuccess()
    }
    
    func presentError(_ error: ForgotPasswordPresenter.ResetPasswordError) {
        switch error {
        case .incorrectEmail:
            viewController?.handle(error: error, inField: .email)
        default:
            viewController?.handle(error: error)
        }
    }
}
