import UIKit

protocol DoctorLocationBusinessLogic {
    func cancelVisit(for booking: Booking)
    func observeDoctorLocation(for booking: Booking)
    func stopObservingDoctorLocation()
}

class DoctorLocationInteractor: DoctorLocationBusinessLogic {
	var presenter: DoctorLocationPresentationLogic?
	var worker = DoctorLocationWorker()

	// MARK: Business logic
    
    func cancelVisit(for booking: Booking) {
        worker.cancelVisit(with: booking) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            self.presenter?.visitCancelled()
        }
    }
    
    func observeDoctorLocation(for booking: Booking) {
        worker.observeDoctorLocation(for: booking) { (location) in
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
