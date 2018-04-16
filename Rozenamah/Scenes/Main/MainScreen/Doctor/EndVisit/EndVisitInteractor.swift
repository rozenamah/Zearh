import UIKit

protocol EndVisitBusinessLogic {
}

class EndVisitInteractor: EndVisitBusinessLogic {
	var presenter: EndVisitPresentationLogic?
	var worker = EndVisitWorker()

	// MARK: Business logic
	
}
