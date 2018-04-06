import UIKit

protocol MainDoctorBusinessLogic: MainScreenBusinessLogic {
    func stopReceivingRequests()
    func startReceivingRequests()
}

class MainDoctorInteractor: MainScreenInteractor, MainDoctorBusinessLogic {
	var presenter: MainDoctorPresentationLogic?
	var worker = MainDoctorWorker()
    override var basePresenter: MainScreenPresenter? {
        return presenter as? MainScreenPresenter
    }

	// MARK: Business logic
	
    func startReceivingRequests() {
        worker.updateAvabilityTo(true) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            self.presenter?.avabilityUpdatedTo(true)
        }
    }
    
    func stopReceivingRequests() {
        worker.updateAvabilityTo(false) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            self.presenter?.avabilityUpdatedTo(false)
        }
    }
}
