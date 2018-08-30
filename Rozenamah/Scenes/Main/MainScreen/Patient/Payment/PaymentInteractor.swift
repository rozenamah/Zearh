import UIKit

protocol PaymentBusinessLogic {
    func fetchPaymentProfile()
    func cancelVisitRequestFor(booking: Booking)
}

class PaymentInteractor: PaymentBusinessLogic {
	var presenter: PaymentPresentationLogic?
	var worker = PaymentWorker()
    private let doctorLocationWorker = DoctorLocationWorker()

	// MARK: Business logic
	
    func fetchPaymentProfile() {
        worker.fetchPaymentProfile { [weak self] (profileDetails, error) in
            self?.presenter?.presentPaymentProfileWith(profile: profileDetails)
        }
    }
    
    func cancelVisitRequestFor(booking: Booking) {
        doctorLocationWorker.cancelVisit(with: booking) { [weak self] (error) in
            if let error = error {
                self?.presenter?.handleError(error)
                return
            }
            self?.presenter?.visitCancelled()
        }
    }
    
}
