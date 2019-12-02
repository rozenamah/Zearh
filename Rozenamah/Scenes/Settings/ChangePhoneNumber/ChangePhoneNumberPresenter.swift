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
        case unknownError(RMError)
        
        var errorDescription: String? {
            switch self {
            case .incorrectNumber:
                return "errors.incorrectNumber".localized
            case .numberTaken:
                return "errors.numberTaken".localized
            case .unknownError(let error):
                if let errorMsg = error.localizedDescription.localizedError {
                    return errorMsg
                }
                return "generic.error.unknowon".localized
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
            presentError(.unknownError(error))
        }
    }
    
    func numberChangedSuccessful() {
        viewController?.phoneNumberChangedSuccessful()
    }
    
	
}
