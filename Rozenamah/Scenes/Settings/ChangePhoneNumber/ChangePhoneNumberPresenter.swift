import UIKit

protocol ChangePhoneNumberPresentationLogic {
    func presentError(_ error: ChangePhoneNumberPresenter.ChangeNumberError)
    func handle(_ error: RMError)
    func numberChangedSuccessful()
}

class ChangePhoneNumberPresenter: ChangePhoneNumberPresentationLogic {
	weak var viewController: ChangePhoneNumberDisplayLogic?

	// MARK: Presentation logic
    
    enum ChangeNumberError: LocalizedError {
        case numberTaken
        case incorrectNumber
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .incorrectNumber:
                return "Phone number is incorrect"
            case .numberTaken:
                return "Phone number is already taken"
            case .unknownError:
                return "Unknown error"
            }
        }
    }
    
    func presentError(_ error: ChangePhoneNumberPresenter.ChangeNumberError) {
        viewController?.displayError(error)
    }
    
    func handle(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .duplicate:
            presentError(.numberTaken)
        default:
            presentError(.unknownError)
        }
    }
    
    func numberChangedSuccessful() {
        viewController?.phoneNumberChangedSuccessful()
    }
    
	
}
