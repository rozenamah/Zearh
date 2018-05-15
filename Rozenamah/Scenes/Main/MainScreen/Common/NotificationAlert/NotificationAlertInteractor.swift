import UIKit

protocol NotificationAlertBusinessLogic {
}

class NotificationAlertInteractor: NotificationAlertBusinessLogic {
	var presenter: NotificationAlertPresentationLogic?
	var worker = NotificationAlertWorker()

	// MARK: Business logic
	
}
