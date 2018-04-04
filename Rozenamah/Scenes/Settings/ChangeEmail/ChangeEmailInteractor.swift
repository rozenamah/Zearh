import UIKit

protocol ChangeEmailBusinessLogic {
    func changeEmail(_ email: String)
    func validate(_ email :String) -> Bool
}

class ChangeEmailInteractor: ChangeEmailBusinessLogic {
	var presenter: ChangeEmailPresentationLogic?
	var worker = ChangeEmailWorker()

	// MARK: Business logic
    
    func changeEmail(_ email: String) {
        worker.changeEmail(email) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
            } else {
                self.presenter?.emailChangedSuccessful()
            }
        }
    }
    
    func validate(_ email: String) -> Bool {
        var isEmailValid = true
        
        // Email verification
        if !EmailValidation.validate(email: email) {
            isEmailValid = false
            presenter?.presentError(.incorrectEmail)
        }
        return isEmailValid
    }
}
