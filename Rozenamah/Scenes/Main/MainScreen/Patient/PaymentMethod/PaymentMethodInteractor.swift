import UIKit

protocol PaymentMethodBusinessLogic {
}

class PaymentMethodInteractor: PaymentMethodBusinessLogic {
	var presenter: PaymentMethodPresentationLogic?
	var worker = PaymentMethodWorker()

	// MARK: Business logic
	
}
