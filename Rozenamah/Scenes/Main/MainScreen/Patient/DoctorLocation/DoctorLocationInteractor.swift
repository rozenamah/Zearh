import UIKit

protocol DoctorLocationBusinessLogic {
    func cancelVisit(for visitId: String)
    func observeDoctorLocation(for visitId: String)
    func stopObservingDoctorLocation()
}

class DoctorLocationInteractor: DoctorLocationBusinessLogic {
	var presenter: DoctorLocationPresentationLogic?
	var worker = DoctorLocationWorker()

	// MARK: Business logic
    
    func cancelVisit(for visitId: String) {
        worker.cancelVisit(with: visitId) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            self.presenter?.visitCancelled()
        }
    }
    
    func observeDoctorLocation(for visitId: String) {
        worker.observeDoctorLocation(for: visitId) { (location) in
            if let location = location {
                self.presenter?.updateDoctorLocation(location)
            }
        }
    }
    
    func stopObservingDoctorLocation() {
        //TODO: Trigger this function when needed
        worker.stopObservingDoctorLocation()
    }
	
}
