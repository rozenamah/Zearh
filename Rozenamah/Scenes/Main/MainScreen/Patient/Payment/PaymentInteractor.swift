import UIKit

protocol PaymentBusinessLogic {
}

class PaymentInteractor: PaymentBusinessLogic {
	var presenter: PaymentPresentationLogic?
	var worker = PaymentWorker()

	// MARK: Business logic
	
}
