import UIKit
import KeychainAccess
import Alamofire

protocol RegisterPatientBusinessLogic {
    func validate(registerForm: RegisterForm) -> Bool
    func register(withForm form: RegisterForm)
}

class RegisterPatientInteractor: RegisterPatientBusinessLogic {
	var presenter: RegisterPatientPresentationLogic?
	var worker = RegisterPatientWorker()

	// MARK: Business logic
	
    func register(withForm form: RegisterForm) {
        
        worker.register(withForm: form) { (response, error) in
            // Error handling
            if let error = error {
                self.presenter?.handleError(error)
            }

            if let response = response {
                // Save token in keychain
                Keychain.shared.token = response.token
                
                // Save user in current
                User.current = response.user
                
                self.presenter?.presentRegisterSuccess()
            }

        }
    }
    
    func validate(registerForm: RegisterForm) -> Bool {
        
        var allFieldsValid = true
        
        // Email verification
        if registerForm.email == nil ||
            !EmailValidation.validate(email: registerForm.email!) {
            
            allFieldsValid = false
            presenter?.presentError(.incorrectEmail)
        }
        
        // Password verification
        if registerForm.password == nil ||
            registerForm.password!.count < 4 {
            allFieldsValid = false
            presenter?.presentError(.passwordToShort)
        } else if registerForm.password == nil ||
            registerForm.password!.count > 30 {
            
            allFieldsValid = false
            presenter?.presentError(.passwordToLong)
        } else if registerForm.password != registerForm.repeatPassword {
            // Check if passwords are the same
            
            allFieldsValid = false
            presenter?.presentError(.passwordsDifferent)
        }
        
        // Name verification
        if registerForm.name == nil ||
            registerForm.name!.count < 3  {
            
            allFieldsValid = false
            presenter?.presentError(.nameToShort)
        } else if registerForm.name == nil ||
            registerForm.name!.count > 30 {
            
            allFieldsValid = false
            presenter?.presentError(.nameToLong)
        }
        
        // Surname verification
        if registerForm.surname == nil ||
            registerForm.surname!.count < 3  {
            
            allFieldsValid = false
            presenter?.presentError(.surnameToShort)
        } else if registerForm.surname == nil ||
            registerForm.surname!.count > 30 {
            
            allFieldsValid = false
            presenter?.presentError(.surnameToLong)
        }
        
        return allFieldsValid
    }
}
