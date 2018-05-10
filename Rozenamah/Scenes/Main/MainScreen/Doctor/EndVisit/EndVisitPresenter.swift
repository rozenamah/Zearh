import UIKit

protocol EndVisitPresentationLogic {
    func handle(_ error: Error)
    func doctorEnded(booking: Booking)
    func presentError(_ error: EndVisitPresenter.EndVisitError) 
}

class EndVisitPresenter: EndVisitPresentationLogic {
	weak var viewController: EndVisitDisplayLogic?

	// MARK: Presentation logic
	
    enum EndVisitError: LocalizedError {
        case cashNotTaken
        case unknown(Error?)
        
        var errorDescription: String? {
            switch self {
            case .cashNotTaken:
                return "You have to confirm that you received money from patient"
            case .unknown(let error):
                if let error = error {
                    return error.localizedDescription
                }
                return "generic.error.unknown".localized
            }
        }
    }
    
    func handle(_ error: Error) {
        viewController?.handleError(error)
    }
    
    func doctorEnded(booking: Booking) {
        viewController?.visitEnded()
    }
    
    func presentError(_ error: EndVisitPresenter.EndVisitError) {
        switch error {
        default:
            viewController?.handleError(error)
        }
    }
}
