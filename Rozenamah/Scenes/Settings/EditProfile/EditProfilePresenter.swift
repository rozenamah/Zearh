import UIKit

protocol EditProfilePresentationLogic {
    func profileUpdated()
    func handleError(_ error: RMError)
    func presentError(_ error: EditProfilePresenter.EditProfileError)
}

protocol EditProfileError: LocalizedError {
}

class EditProfilePresenter: EditProfilePresentationLogic {
	weak var viewController: EditProfileDisplayLogic?

	// MARK: Presentation logic
    
    enum EditProfileError: LocalizedError {
        case surnameToLong
        case nameToLong
        case nameToShort
        case incorrectName
        case incorrectSurname
        case surnameToShort
        case unknown(Error?)
        case professionMissing
        case specializationMissing
        case priceMissing
        
        var errorDescription: String? {
            switch self {
            case .incorrectName:
                return "Name is incorrect"
            case .surnameToLong:
                return "Surname can have maximum 30 characters"
            case .surnameToShort:
                return "Surname must have at least 3 characters"
            case .incorrectSurname:
                return "Surname is incorrect"
            case .nameToLong:
                return "Name can have maximum 30 characters"
            case .nameToShort:
                return "Name must have at least 3 characters"
            case .professionMissing:
                return "You need to choose your classification"
            case .specializationMissing:
                return "You need to choose your specialization"
            case .priceMissing:
                return "You need to specify your price"
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
                }
                return "Unknown error"
            }
        }
    }
    
    func handleError(_ error: RMError) {
        switch error {
        default:
            viewController?.displayError()
        }
    }
    
    func presentError(_ error: EditProfilePresenter.EditProfileError) {
        switch error {
        case .incorrectName, .nameToLong,.nameToShort:
            viewController?.handle(error: error, inField: .name)
        case .incorrectSurname, .surnameToLong, .surnameToShort:
            viewController?.handle(error: error, inField: .surname)
        case .professionMissing:
            viewController?.handle(error: error, inField: .classification)
        case .specializationMissing:
             viewController?.handle(error: error, inField: .specialization)
        case .priceMissing:
             viewController?.handle(error: error, inField: .price)
        default:
            viewController?.displayError()
        }
    }
    
    func profileUpdated() {
        viewController?.profileUpdatedSuccessful()
    }
}
