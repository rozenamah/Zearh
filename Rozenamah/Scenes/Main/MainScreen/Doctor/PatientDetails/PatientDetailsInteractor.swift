import UIKit

protocol PatientDetailsBusinessLogic {
}

class PatientDetailsInteractor: PatientDetailsBusinessLogic {
	var presenter: PatientDetailsPresentationLogic?
	var worker = PatientDetailsWorker()

	// MARK: Business logic
	
}
