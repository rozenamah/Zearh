import UIKit

protocol PaymentMethodPresentationLogic {
    func handleError(_ error: RMError)
}

class PaymentMethodPresenter: PaymentMethodPresentationLogic {
	weak var viewController: PaymentMethodDisplayLogic?

	// MARK: Presentation logic
	
    // Called with API calls, depending on response error we can preset different
    // messages
    func handleError(_ error: RMError) {
        switch error {
        default:
            viewController?.handle(error: error)
        }
    }
}
