import UIKit
import Alamofire

protocol WaitBusinessLogic {
    func searchForDoctor(withFilters form: CallDoctorForm)
    func cancelCurrentRequest()
    func cancel(booking: Booking)
}

class WaitInteractor: WaitBusinessLogic {
	var presenter: WaitPresentationLogic?
	var worker = WaitWorker()

    /// We save request in order to be able to cancel it
    var request: DataRequest?
    
	// MARK: Business logic
	
    func searchForDoctor(withFilters form: CallDoctorForm) {
        request = worker.searchForDoctos(withFilters: form) { (doctor, error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            if let doctor = doctor {
                self.presenter?.presentDoctor(doctor)
            }
        }
    }
    
    func cancel(booking: Booking) {
        DoctorOnTheWayWorker().cancelVisit(with: booking) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            self.presenter?.visitCancelled()
        }
    }
    
    func cancelCurrentRequest() {
        request?.cancel()
    }
}
