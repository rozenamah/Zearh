import UIKit

protocol ReportBusinessLogic {
    func reportSubject(_ reportForm: ReportForm)
    func validate(_ reportForm: ReportForm?) -> Bool
}

class ReportInteractor: ReportBusinessLogic {
	var presenter: ReportPresentationLogic?
	var worker = ReportWorker()

	// MARK: Business logic
    
    func reportSubject(_ reportForm: ReportForm) {
        
    }
	
    func validate(_ reportForm: ReportForm?) -> Bool {
        var allFieldsValid = true
        
        // Validate subject
        if reportForm?.subject == nil {
            allFieldsValid = false
            presenter?.presentError(.subjectMissing)
        }
        // Validate text
        if reportForm?.text == nil || reportForm?.text!.isEmpty == true {
            allFieldsValid = false
            presenter?.presentError(.messageMissing)
        }
        
        return allFieldsValid
    }
}
