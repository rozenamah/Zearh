import UIKit

protocol ChangePasswordBusinessLogic {
    func validate(_ changePasswordForm: ChangePasswordForm) -> Bool
    func changePassword(_ changePasswordForm: ChangePasswordForm)

}

class ChangePasswordInteractor: ChangePasswordBusinessLogic {
	var presenter: ChangePasswordPresentationLogic?
	var worker = ChangePasswordWorker()

	// MARK: Business logic
    
    func changePassword(_ changePasswordForm: ChangePasswordForm) {
        worker.changePassword(changePasswordForm) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
            } else {
                self.presenter?.passwordChangedSuccessful()
            }
        }
    }
    
    func validate(_ changePasswordForm: ChangePasswordForm) -> Bool {
        var allFieldsValid = true
        
        // Old password validation
        if changePasswordForm.currentPassword == nil || changePasswordForm.currentPassword!.count < 4 {
            allFieldsValid = false
            presenter?.presentError(.currentPasswordToShort)
        } else if !PasswordValidation.validate(password: changePasswordForm.currentPassword!) {
            allFieldsValid = false
            presenter?.presentError(.incorrectPassword)
        }
        
        // New password validation
        if changePasswordForm.newPassword == nil || changePasswordForm.newPassword!.count < 4 {
            allFieldsValid = false
            presenter?.presentError(.newPasswordToShort)
        } else if changePasswordForm.newPassword == nil || changePasswordForm.newPassword!.count > 30 {
            allFieldsValid = false
            presenter?.presentError(.newPasswordToLong)
        } else if changePasswordForm.newPassword == nil ||
            !PasswordValidation.validate(password: changePasswordForm.newPassword!) {
            allFieldsValid = false
            presenter?.presentError(.incorrectPassword)
        }
        
        // Confirm password validation
        if changePasswordForm.confirmPassword == nil || changePasswordForm.confirmPassword != changePasswordForm.newPassword {
            allFieldsValid = false
            presenter?.presentError(.passwordsDontMatch)
        }
        
        return allFieldsValid
    }
}
