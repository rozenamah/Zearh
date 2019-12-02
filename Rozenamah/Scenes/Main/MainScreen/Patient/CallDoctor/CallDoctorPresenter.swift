import UIKit

protocol CallDoctorPresentationLogic {
    func presentError(_ error: CallDoctorPresenter.CallDoctorError)
    func handleError(_ error: RMError)
}

class CallDoctorPresenter: CallDoctorPresentationLogic {
	weak var viewController: CallDoctorDisplayLogic?

	// MARK: Presentation logic
	
    enum CallDoctorError: LocalizedError {
        case professionMissing
        case specializationMissing
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .professionMissing:
                return "errors.professionMissing".localized
            case .specializationMissing:
                return "errors.specializationMissing".localized
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
        default:
            presentError(.unknown(error))
        }
    }
    
    func presentError(_ error: CallDoctorPresenter.CallDoctorError) {
        
        switch error {
        case .professionMissing:
            viewController?.handle(error: error, inField: .classification)
        case .specializationMissing:
            viewController?.handle(error: error, inField: .specialization)
        default:
            viewController?.handle(error: error)
        }
        
    }

}
