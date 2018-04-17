import UIKit

protocol RegisterPatientPresentationLogic {
    func presentError(_ error: RegisterPatientPresenter.RegisterPatientError)
    func handleError(_ error: RMError) 
    func presentRegisterSuccess()
    func presentEmailIsUnique()
}

class RegisterPatientPresenter: RegisterPatientPresentationLogic {
	weak var viewController: RegisterPatientDisplayLogic?

    enum RegisterPatientError: LocalizedError {
        case incorrectEmail
        case incorrectPhone
        case emailAlreadyExists
        case phoneAlreadyExists
        case passwordToShort
        case passwordToLong
        case incorrectPassword
        case passwordsDifferent
        case surnameToLong
        case nameToLong
        case nameToShort
        case incorrectName
        case incorrectSurname
        case surnameToShort
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .emailAlreadyExists:
                return "Email is already taken"
            case .phoneAlreadyExists:
                return "Phone is already taken"
            case .incorrectEmail:
                return "session.login.error.incorrectEmail".localized
            case .incorrectPhone:
                return "session.patient.error.incorrectPhone".localized
            case .incorrectPassword:
                return "session.patient.error.incorrectPassword".localized
            case .incorrectName:
                return "session.patient.error.incorrectName".localized
            case .incorrectSurname:
                return "session.patient.error.incorrectSurname".localized
            case .passwordToShort:
                return "session.login.error.passwordTooShort".localized
            case .passwordToLong:
                return "session.login.error.passwordTooLong".localized
            case .nameToLong:
                return "session.patient.error.nameTooLong".localized
            case .surnameToLong:
                return "session.patient.error.surnameTooLong".localized
            case .nameToShort:
                return "session.patient.error.nameTooShort".localized
            case .surnameToShort:
                return "session.patient.error.surnameTooShort".localized
            case .passwordsDifferent:
                return "session.patient.error.diffrentPasswords".localized
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
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
        case .status(let code, let error) where code == .duplicate:
            if error.cause == "email" {
                presentError(.emailAlreadyExists)
            } else {
                presentError(.phoneAlreadyExists)
            }
        default:
            presentError(.unknown(error))
        }
    }
    
    func presentError(_ error: RegisterPatientPresenter.RegisterPatientError) {
        
        switch error {
        case .incorrectEmail, .emailAlreadyExists:
            viewController?.handle(error: error, inField: .email)
        case .incorrectPhone, .phoneAlreadyExists:
            viewController?.handle(error: error, inField: .phone)
        case .passwordToShort, .passwordToLong, .incorrectPassword:
            viewController?.handle(error: error, inField: .password)
        case .nameToLong, .nameToShort, .incorrectName:
            viewController?.handle(error: error, inField: .name)
        case .surnameToLong, .surnameToShort, .incorrectSurname:
            viewController?.handle(error: error, inField: .surname)
        case .passwordsDifferent:
            viewController?.handle(error: error, inField: .confirmPassword)
        default:
            viewController?.handle(error: error)
        }
        
    }
    
    func presentEmailIsUnique() {
        viewController?.continueToNextStep()
    }
	
    func presentRegisterSuccess() {
        viewController?.registerSuccess()
    }
}
