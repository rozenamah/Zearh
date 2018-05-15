import UIKit

protocol LocationAlertBusinessLogic {
}

class LocationAlertInteractor: LocationAlertBusinessLogic {
	var presenter: LocationAlertPresentationLogic?
	var worker = LocationAlertWorker()

	// MARK: Business logic
	
}
