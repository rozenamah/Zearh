import UIKit

protocol WaitBusinessLogic {
}

class WaitInteractor: WaitBusinessLogic {
	var presenter: WaitPresentationLogic?
	var worker = WaitWorker()

	// MARK: Business logic
	
}
