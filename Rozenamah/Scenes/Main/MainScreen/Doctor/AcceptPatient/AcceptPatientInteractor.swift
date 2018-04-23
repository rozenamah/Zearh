import UIKit

protocol AcceptPatientBusinessLogic {
    func rejectPatient(for visitId: String)
    func acceptPatient(for visitId: String)
}

class AcceptPatientInteractor: AcceptPatientBusinessLogic {
	var presenter: AcceptPatientPresentationLogic?
	var worker = AcceptPatientWorker()

	// MARK: Business logic
    
    
    func rejectPatient(for visitId: String) {
        worker.rejectPatient(for: visitId) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            self.presenter?.patienRejected()
        }
    }
    
    func acceptPatient(for visitId: String) {
        worker.acceptPatient(for: visitId) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            self.presenter?.patientAccepted()
        }
    }
	
}
