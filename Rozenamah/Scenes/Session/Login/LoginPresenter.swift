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
                return "session.login.error.incorrectEmail".localized
            case .passwordToShort:
                return "session.login.error.passwordTooShort".localized
            case .blockedUser:
                return "session.login.error.blockedUser".localized
            case .passwordToLong:
                return "session.login.error.passwordTooLong".localized
            case .loginOrPasswordInvalid:
                return "session.login.error.invalidEmailPassword".localized
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription.localizedError ?? error.localizedDescription
                }
                return "generic.error.unknown".localized
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
