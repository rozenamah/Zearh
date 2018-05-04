import UIKit

protocol AcceptPatientBusinessLogic {
    func rejectPatient(for booking: Booking)
    func acceptPatient(for booking: Booking)
}

class AcceptPatientInteractor: AcceptPatientBusinessLogic {
	var presenter: AcceptPatientPresentationLogic?
	var worker = AcceptPatientWorker()

	// MARK: Business logic
    
    func rejectPatient(for booking: Booking) {
        worker.rejectPatient(for: booking) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            self.presenter?.patienRejected()
        }
    }
    
    func acceptPatient(for booking: Booking) {
        worker.acceptPatient(for: booking) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            self.presenter?.patientAccepted(with: nil)
            // TODO: Change it when data will be available from API
//            if let booking = booking {
//                 self.presenter?.patientAccepted(with: booking)
//            }
           
        }
    }
	
}
