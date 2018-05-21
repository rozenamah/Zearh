import UIKit

protocol EditProfilePresentationLogic {
    func profileUpdated()
    func presentDeleteSuccess()
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
        case professionMissing
        case specializationMissing
        case priceMissing
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .incorrectName:
                return "session.patient.incorrectName".localized
            case .surnameToLong:
                return "session.patient.error.surnameTooLong".localized
            case .surnameToShort:
                return "session.patient.error.surnameTooShort".localized
            case .incorrectSurname:
                return "session.patient.error.incorrectSurname".localized
            case .nameToLong:
                return "session.patient.error.nameTooLong".localized
            case .nameToShort:
                return "session.patient.error.nameTooShort".localized
            case .professionMissing:
                return "session.doctor.error.professionMissing".localized
            case .specializationMissing:
                return "session.doctor.error.specializationMissing".localized
            case .priceMissing:
                return "session.doctor.error.priceMissing".localized
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
                }
                return "generic.error.unknown".localized
            }
        }
    }
    
    func handleError(_ error: RMError) {
        switch error {
        default:
            presentError(.unknown(error))
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
            viewController?.handle(error: error)
        }
    }
    
    func presentDeleteSuccess() {
        viewController?.deleteSuccess()
    }
    
    func profileUpdated() {
        viewController?.profileUpdatedSuccessful()
    }
}
