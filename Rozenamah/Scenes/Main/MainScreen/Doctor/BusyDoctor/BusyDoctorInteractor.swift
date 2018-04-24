import UIKit

protocol BusyDoctorBusinessLogic {
}

class BusyDoctorInteractor: BusyDoctorBusinessLogic {
	var presenter: BusyDoctorPresentationLogic?
	var worker = BusyDoctorWorker()

	// MARK: Business logic
	
}
