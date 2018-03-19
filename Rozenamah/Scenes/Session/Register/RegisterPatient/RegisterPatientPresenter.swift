import UIKit

protocol RegisterPatientPresentationLogic {
    func presentError(_ error: RegisterPatientPresenter.RegisterPatientError)
    func handleError(_ error: RMError) 
    func presentRegisterSuccess()
}

class RegisterPatientPresenter: RegisterPatientPresentationLogic {
	weak var viewController: RegisterPatientDisplayLogic?

    enum RegisterPatientError: LocalizedError {
        case incorrectEmail
        case emailAlreadyExists
        case passwordToShort
        case passwordToLong
        case passwordsDifferent
        case surnameToLong
        case nameToLong
        case nameToShort
        case surnameToShort
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .emailAlreadyExists:
                return "Email is already taken"
            case .incorrectEmail:
                return "Email is incorrect"
            case .passwordToShort:
                return "Password must have at least 4 characters"
            case .passwordToLong:
                return "Password can have maximum 30 characters"
            case .nameToLong:
                return "Name can have maximum 30 characters"
            case .surnameToLong:
                return "Surname can have maximum 30 characters"
            case .nameToShort:
                return "Name must have at least 3 characters"
            case .surnameToShort:
                return "Surname must have at least 3 characters"
            case .passwordsDifferent:
                return "Passwords are not the same"
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
        default:
            presentError(.unknown(error))
        }
    }
    
    func presentError(_ error: RegisterPatientPresenter.RegisterPatientError) {
        
        switch error {
        case .incorrectEmail, .emailAlreadyExists:
            viewController?.handle(error: error, inField: .email)
        case .passwordToShort:
            viewController?.handle(error: error, inField: .password)
        case .passwordToLong:
            viewController?.handle(error: error, inField: .password)
        case .nameToLong:
            viewController?.handle(error: error, inField: .name)
        case .surnameToLong:
            viewController?.handle(error: error, inField: .surname)
        case .nameToShort:
            viewController?.handle(error: error, inField: .name)
        case .surnameToShort:
            viewController?.handle(error: error, inField: .surname)
        case .passwordsDifferent:
            viewController?.handle(error: error, inField: .confirmPassword)
        default:
            viewController?.handle(error: error)
        }
        
    }
	
    func presentRegisterSuccess() {
        viewController?.registerSuccess()
    }
}
