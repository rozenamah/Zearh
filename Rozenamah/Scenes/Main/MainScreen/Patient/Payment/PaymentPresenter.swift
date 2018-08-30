import UIKit

protocol PaymentPresentationLogic {
    func presentPaymentProfileWith(profile: Payment.Details?)
    func handleError(_ error: RMError)
    func visitCancelled()
}

class PaymentPresenter: PaymentPresentationLogic {
	weak var viewController: PaymentDisplayLogic?

	// MARK: Presentation logic
    
    func presentPaymentProfileWith(profile: Payment.Details?) {
        viewController?.displayPaymentProfileWith(profile: profile)
    }
    
    func handleError(_ error: RMError) {
        switch error {
        case .status(let code, _) where code == .badRequest:
            viewController?.handle(error: error)
            break
        default:
            viewController?.handle(error: error)
        }
    }

    func visitCancelled() {
        viewController?.visitCancelled()
    }
    
}
