import UIKit

protocol ChangeEmailBusinessLogic {
    func checkIfEmailTaken(_ email: String)
    func changeEmail(_ email: String)
    func validate(_ email :String) -> Bool
}

class ChangeEmailInteractor: ChangeEmailBusinessLogic {
	var presenter: ChangeEmailPresentationLogic?
	var worker = ChangeEmailWorker()
    var registerWorker = RegisterPatientWorker()

	// MARK: Business logic
	
    func checkIfEmailTaken(_ email: String) {
        registerWorker.verifyIfEmailTaken(email) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
        }
        presenter?.emailIsUnique()
    }
    
    func changeEmail(_ email: String) {
        
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
