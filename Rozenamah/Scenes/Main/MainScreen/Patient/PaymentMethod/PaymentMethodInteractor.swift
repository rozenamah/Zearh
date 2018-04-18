import UIKit

protocol PaymentMethodBusinessLogic {
    func accept(doctor: User, withPaymentMethod paymentMethod: PaymentMethod)
}

class PaymentMethodInteractor: PaymentMethodBusinessLogic {
	var presenter: PaymentMethodPresentationLogic?
	var worker = PaymentMethodWorker()

	// MARK: Business logic
	
    func accept(doctor: User, withPaymentMethod paymentMethod: PaymentMethod) {
        
        worker.accept(doctor: doctor, withPaymentMethod: paymentMethod) { (error) in
            
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
        }
        
    }
}
