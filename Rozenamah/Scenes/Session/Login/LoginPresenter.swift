import UIKit

protocol LoginPresentationLogic {
    func presentError(_ error: LoginPresenter.LoginError)
    func handleError(_ error: RMError)
    func presentLoginSuccess()
}

class LoginPresenter: LoginPresentationLogic {
	weak var viewController: LoginDisplayLogic?

    enum LoginError: LocalizedError {
        case incorrectEmail
        case loginOrPasswordInvalid
        case passwordToShort
        case passwordToLong
        case blockedUser
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .incorrectEmail:
                return "Email/Number is incorrect"
            case .passwordToShort:
                return "Password must have at least 4 characters"
            case .blockedUser:
                return "This user is blocked"
            case .passwordToLong:
                return "Password can have maximum 30 characters"
            case .loginOrPasswordInvalid:
                return "Email/Number or password invalid"
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
                }
                return "Unknown error"
            }
        }
    }
    
	// MARK: Presentation logic
    
    // Called with API calls, depending on response error we can preset different
    // messages
    func handleError(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .unauthorized :
            presentError(.loginOrPasswordInvalid)
        case .status(let code, _) where code == .forbidden :
            presentError(.blockedUser)
        default:
            presentError(.unknown(error))
        }
    }
	
    func presentError(_ error: LoginPresenter.LoginError) {
        switch error {
        case .incorrectEmail, .loginOrPasswordInvalid:
            viewController?.handle(error: error, inField: .email)
        case .passwordToShort, .passwordToLong:
            viewController?.handle(error: error, inField: .password)
        default:
            viewController?.handle(error: error)
        }
    }
    
    func presentLoginSuccess() {
        viewController?.loginSuccess()
    }
}
