import UIKit

protocol EndVisitPresentationLogic {
    func handle(_ error: Error)
    func doctorEnded(booking: Booking)
}

class EndVisitPresenter: EndVisitPresentationLogic {
	weak var viewController: EndVisitDisplayLogic?

	// MARK: Presentation logic
	
    func handle(_ error: Error) {
        viewController?.handleError(error)
    }
    
    func doctorEnded(booking: Booking) {
        viewController?.visitEnded()
    }
    
}
