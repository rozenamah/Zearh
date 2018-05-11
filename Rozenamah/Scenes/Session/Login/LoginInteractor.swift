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
                Keychain.shared.refreshToken = response.refreshToken
                
                // Save user in current
                User.current = response.user
                
                // Also - load if user has any pending visit
                SplashWorker().fetchMyBooking(completion: { (booking, error) in
                    
                    // Save launch booking in app delegate
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.launchBooking = booking
                    }
                    
                    self.presenter?.presentLoginSuccess()
                })
                
            }
            
        }
    }
    
    func validate(loginForm: LoginForm) -> Bool {
        
        var allFieldsValid = true
        
        if loginForm.login == nil ||
            !(EmailValidation.validate(email: loginForm.login!)
                || PhoneValidation.validate(phone: loginForm.login!)) {
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
