import UIKit

protocol WelcomeBusinessLogic {
}

class WelcomeInteractor: WelcomeBusinessLogic {
	var presenter: WelcomePresentationLogic?
	var worker = WelcomeWorker()

	// MARK: Business logic
	
}
