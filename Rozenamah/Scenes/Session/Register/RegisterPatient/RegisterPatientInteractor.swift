import UIKit
import KeychainAccess
import Alamofire

protocol RegisterPatientBusinessLogic {
    func validate(registerForm: RegisterForm) -> Bool
    func checkIfEmailTaken(_ email: String)
    func register(withForm form: RegisterForm)
}

class RegisterPatientInteractor: RegisterPatientBusinessLogic {
	var presenter: RegisterPatientPresentationLogic?
	var worker = RegisterPatientWorker()

	// MARK: Business logic
	
    func checkIfEmailTaken(_ email: String) {
        worker.verifyIfEmailTaken(email) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            self.presenter?.presentEmailIsUnique()
        }
    }
    
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
        
        // Phone verification
        if registerForm.phone == nil ||
            !PhoneValidation.validate(phone: registerForm.phone!) {
            
            allFieldsValid = false
            presenter?.presentError(.incorrectPhone)
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
        }  else if registerForm.password == nil ||
            !PasswordValidation.validate(password: registerForm.password!) {
            
            allFieldsValid = false
            presenter?.presentError(.incorrectPassword)
        } else if registerForm.password != registerForm.repeatPassword {
            // Check if passwords are the same
            
            allFieldsValid = false
            presenter?.presentError(.passwordsDifferent)
        }
        
        // Name verification
        if let name = registerForm.name {
            if name.count < 3 {
                allFieldsValid = false
                presenter?.presentError(.nameToShort)
            } else if name.count > 30 {
                allFieldsValid = false
                presenter?.presentError(.nameToLong)
            } else if !NameValidation.validate(name: name) {
                allFieldsValid = false
                presenter?.presentError(.incorrectName)
            }
        } else {
            allFieldsValid = false
            presenter?.presentError(.nameToShort)
        }
        
        // Surname verification
        if let surname = registerForm.surname {
            if surname.count < 3 {
                allFieldsValid = false
                presenter?.presentError(.surnameToShort)
            } else if surname.count > 30 {
                allFieldsValid = false
                presenter?.presentError(.surnameToLong)
            } else if !NameValidation.validate(name: surname) {
                allFieldsValid = false
                presenter?.presentError(.incorrectSurname)
            }
        } else {
            allFieldsValid = false
            presenter?.presentError(.surnameToShort)
        }
    
        return allFieldsValid
    }
}
