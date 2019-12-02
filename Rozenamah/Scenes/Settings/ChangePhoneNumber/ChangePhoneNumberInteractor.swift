import UIKit

protocol ChangePhoneNumberBusinessLogic {
    func validatePhoneNumber(_ numberForm: PhoneNumberForm) -> Bool
    func changePhoneNumber(_ numberForm: ParamForm)
}

class ChangePhoneNumberInteractor: ChangePhoneNumberBusinessLogic {
	var presenter: ChangePhoneNumberPresentationLogic?
	var worker = ChangePhoneNumberWorker()

	// MARK: Business logic
    
    func changePhoneNumber(_ numberForm: ParamForm) {
        worker.editUserProfile(profileForm: numberForm) { (response, error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            if let response = response {
                // Save user in current
                User.current = response
                
                self.presenter?.numberChangedSuccessful()
            }
        }
    }
    
    func validatePhoneNumber(_ numberForm: PhoneNumberForm) -> Bool {
        var isPhoneNumberValid = true
        if numberForm.phoneNumber == nil ||
            !PhoneValidation.validate(phone: numberForm.phoneNumber!) {
            presenter?.presentError(.incorrectNumber)
            isPhoneNumberValid = false
        }
        
       return isPhoneNumberValid
    }
}
