import UIKit
import Alamofire

protocol WaitBusinessLogic {
    func searchForDoctor(withFilters form: CallDoctorForm)
    func cancelCurrentRequest()
}

class WaitInteractor: WaitBusinessLogic {
	var presenter: WaitPresentationLogic?
	var worker = WaitWorker()

    /// We save request in order to be able to cancel it
    var request: DataRequest?
    
	// MARK: Business logic
	
    func searchForDoctor(withFilters form: CallDoctorForm) {
        worker.searchForDoctos(withFilters: form) { (doctor, error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            if let user = doctor {
                self.presenter?.presentDoctor(user)
            }
        }
    }
    
    func cancelCurrentRequest() {
        request?.cancel()
    }
}
