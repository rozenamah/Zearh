import UIKit
import Alamofire
import KeychainAccess

protocol LoginBusinessLogic {
    func validate(loginForm: LoginForm) -> Bool
    func login(withForm form: LoginForm)
}

class LoginInteractor: LoginBusinessLogic {
	var presenter: LoginPresentationLogic?
	var worker = LoginWorker()

	// MARK: Business logic
	
    func login(withForm form: LoginForm) {
        worker.login(withForm: form) { (response, error) in
            // Error handling
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            if let response = response {
                // Save token in keychain
                Keychain.shared.token = response.token
                
                // Save user in current
                User.current = response.user
                
                self.presenter?.presentLoginSuccess()
            }
            
        }
    }
    
    func validate(loginForm: LoginForm) -> Bool {
        
        var allFieldsValid = true
        
        if loginForm.email == nil ||
            !EmailValidation.validate(email: loginForm.email!) {
            allFieldsValid = false
            presenter?.presentError(.incorrectEmail)
        }
        
        if loginForm.password == nil ||
            loginForm.password!.count < 4 {
            allFieldsValid = false
            presenter?.presentError(.passwordToShort)
        } else if loginForm.password == nil ||
            loginForm.password!.count > 30 {
            
            allFieldsValid = false
            presenter?.presentError(.passwordToLong)
        }
        
        return allFieldsValid
    }
    
}
