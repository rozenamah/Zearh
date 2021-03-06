import UIKit

protocol ForgotPasswordBusinessLogic {
    func validate(resetForm: ResetPasswordForm) -> Bool
    func resetPassword(withForm form: ResetPasswordForm)
}

class ForgotPasswordInteractor: ForgotPasswordBusinessLogic {
	var presenter: ForgotPasswordPresentationLogic?
	var worker = ForgotPasswordWorker()

	// MARK: Business logic
	
    func validate(resetForm: ResetPasswordForm) -> Bool {
        
        var allFieldsValid = true
        
        if resetForm.email == nil ||
            !EmailValidation.validate(email: resetForm.email!) {
            allFieldsValid = false
            presenter?.presentError(.incorrectEmail)
        }
        
        return allFieldsValid
    }
    
    func resetPassword(withForm form: ResetPasswordForm) {
        worker.restoreAccount(withEmail: form.email!) { (error) in
            
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            self.presenter?.presentResetSuccess()
        }
    }
    
}
