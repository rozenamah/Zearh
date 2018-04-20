import UIKit

protocol WaitPresentationLogic {
    func handleError(_ error: RMError)
    func presentDoctor(_ doctor: VisitDetails)
}

class WaitPresenter: WaitPresentationLogic {
	weak var viewController: WaitDisplayLogic?

	// MARK: Presentation logic
	
    // Called with API calls, depending on response error we can preset different
    // messages
    func handleError(_ error: RMError) {
        switch error {
        case .noData:
            viewController?.noDoctorFoundMatchingCriteria()
        default:
            viewController?.handle(error: error)
        }
    }
    
    func presentDoctor(_ doctor: VisitDetails) {
        viewController?.found(doctor: doctor)
    }
    
}
