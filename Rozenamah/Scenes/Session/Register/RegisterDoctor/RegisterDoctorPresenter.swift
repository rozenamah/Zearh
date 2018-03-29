import UIKit

protocol RegisterDoctorPresentationLogic {
    func presentError(_ error: RegisterDoctorPresenter.RegisterDoctorError)
    func handleError(_ error: RMError)
    func presentRegisterSuccess()
}

class RegisterDoctorPresenter: RegisterDoctorPresentationLogic {
	weak var viewController: RegisterDoctorDisplayLogic?

	// MARK: Presentation logic
	
    enum RegisterDoctorError: LocalizedError {
        case professionMissing
        case specializationMissing
        case priceMissing
        case genderMissing
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .professionMissing:
                return "You need to choose your classification"
            case .specializationMissing:
                return "You need to choose your specialization"
            case .priceMissing:
                return "You need to specify your price"
            case .genderMissing:
                return "You need to specify your gender"
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
    
    func presentError(_ error: RegisterDoctorPresenter.RegisterDoctorError) {
        
        switch error {
        case .professionMissing:
            viewController?.handle(error: error, inField: .classification)
        case .specializationMissing:
            viewController?.handle(error: error, inField: .specialization)
        case .priceMissing:
            viewController?.handle(error: error, inField: .price)
        case .genderMissing:
            viewController?.handle(error: error, inField: .gender)
        default:
            viewController?.handle(error: error)
        }
        
    }
    
    func presentRegisterSuccess() {
        viewController?.registerSuccess()
    }
}
