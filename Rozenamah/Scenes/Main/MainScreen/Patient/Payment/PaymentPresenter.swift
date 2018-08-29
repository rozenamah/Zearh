import UIKit

protocol PaymentPresentationLogic {
    func presentPaymentProfileWith(profile: Payment.Details?)
}

class PaymentPresenter: PaymentPresentationLogic {
	weak var viewController: PaymentDisplayLogic?

	// MARK: Presentation logic
    
    func presentPaymentProfileWith(profile: Payment.Details?) {
        viewController?.displayPaymentProfileWith(profile: profile)
    }
    
}
