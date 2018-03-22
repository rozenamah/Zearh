import UIKit

protocol RegisterDoctorBusinessLogic {
    func validate(registerForm: RegisterDoctorForm) -> Bool
}

class RegisterDoctorInteractor: RegisterDoctorBusinessLogic {
	var presenter: RegisterDoctorPresentationLogic?
	var worker = RegisterDoctorWorker()

	// MARK: Business logic
	
    func validate(registerForm: RegisterDoctorForm) -> Bool {
        
        var allFieldsValid = true
    
        // Profession verification
        if registerForm.profession == nil {
            allFieldsValid = false
            presenter?.presentError(.professionMissing)
        }
        
        // Specialization verification
        if (registerForm.profession == .consultants ||
            registerForm.profession == .specialist),
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
