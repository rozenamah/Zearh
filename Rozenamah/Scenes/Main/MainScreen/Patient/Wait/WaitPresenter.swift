import UIKit

protocol WaitPresentationLogic {
    func handleError(_ error: RMError)
    func presentDoctor(_ doctor: VisitDetails)
    func visitCancelled()
}

class WaitPresenter: WaitPresentationLogic {
	weak var viewController: WaitDisplayLogic?

	// MARK: Presentation logic
	
    // Called with API calls, depending on response error we can preset different
    // messages
    func handleError(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .badRequest:
            // Propably booking changed it's state, skip this error
            break
        case .noData:
            viewController?.noDoctorFoundMatchingCriteria()
        default:
            viewController?.handle(error: error)
        }
    }
    
    func presentDoctor(_ doctor: VisitDetails) {
        viewController?.found(doctor: doctor)
    }
    
    func visitCancelled() {
        viewController?.visitCancelled()
    }
    
}
