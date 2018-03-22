import UIKit

protocol ReportBusinessLogic {
}

class ReportInteractor: ReportBusinessLogic {
	var presenter: ReportPresentationLogic?
	var worker = ReportWorker()

	// MARK: Business logic
	
}
