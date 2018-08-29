import UIKit

protocol PaymentBusinessLogic {
    func fetchPaymentProfile()
}

class PaymentInteractor: PaymentBusinessLogic {
	var presenter: PaymentPresentationLogic?
	var worker = PaymentWorker()

	// MARK: Business logic
	
    func fetchPaymentProfile() {
        worker.fetchPaymentProfile { [weak self] (profileDetails, error) in
            self?.presenter?.presentPaymentProfileWith(profile: profileDetails)
        }
    }
    
}
