import UIKit

protocol CallDoctorFiltersBusinessLogic {
}

class CallDoctorFiltersInteractor: CallDoctorFiltersBusinessLogic {
	var presenter: CallDoctorFiltersPresentationLogic?
	var worker = CallDoctorFiltersWorker()

	// MARK: Business logic
	
}
