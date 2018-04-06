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
        worker.editUserProfile(profileForm: email) { (response, error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            if let response = response {
                // Save user in current
                User.current = response
                
                self.presenter?.emailChangedSuccessful()
            }
        }
    }
    
    func validate(_ emailForm: EmailForm) -> Bool {
        var isEmailValid = true
        
        // Email verification
        if emailForm.email == nil ||
            !EmailValidation.validate(email: emailForm.email!) {
            
            isEmailValid = false
            presenter?.presentError(.incorrectEmail)
        }
        return isEmailValid
    }
}
