import UIKit

protocol ChangeEmailBusinessLogic {
    func changeEmail(_ email: EmailForm)
    func validate(_ emailForm: EmailForm) -> Bool
}

class ChangeEmailInteractor: ChangeEmailBusinessLogic {
	var presenter: ChangeEmailPresentationLogic?
	var worker = ChangeEmailWorker()

	// MARK: Business logic
    
    func changeEmail(_ email: EmailForm) {
        worker.changeEmail(email) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
            } else {
                self.presenter?.emailChangedSuccessful()
            }
        }
    }
    
    func validate(_ emailForm: EmailForm) -> Bool {
        var isEmailValid = true
        
        // Email verification
        if emailForm.email == nil || !EmailValidation.validate(email: emailForm.email!) {
            isEmailValid = false
            presenter?.presentError(.incorrectEmail)
        }
        return isEmailValid
    }
}
