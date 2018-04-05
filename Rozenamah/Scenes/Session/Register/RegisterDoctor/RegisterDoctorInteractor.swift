import UIKit
import KeychainAccess

protocol RegisterDoctorBusinessLogic {
    func register(withForm form: CreateDoctorForm)
    func validate(registerForm: CreateDoctorForm) -> Bool
}

class RegisterDoctorInteractor: RegisterDoctorBusinessLogic {
	var presenter: RegisterDoctorPresentationLogic?
	var worker = RegisterDoctorWorker()

	// MARK: Business logic
	
    func register(withForm form: CreateDoctorForm) {
        
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
    
    func validate(registerForm: CreateDoctorForm) -> Bool {
        
        var allFieldsValid = true
    
        // Profession verification
        if registerForm.classification == nil {
            allFieldsValid = false
            presenter?.presentError(.professionMissing)
        }
        
        // Specialization verification
        if (registerForm.classification == .consultants ||
            registerForm.classification == .specialist),
            registerForm.specialization == nil  {
            
            allFieldsValid = false
            presenter?.presentError(.specializationMissing)
        }
        
        // Price verification
        if registerForm.price == nil {
            
            allFieldsValid = false
            presenter?.presentError(.priceMissing)
        }
        
        // Gender verification
        if registerForm.gender == nil {
            
            allFieldsValid = false
            presenter?.presentError(.genderMissing)
        }
        
        return allFieldsValid
    }
}
