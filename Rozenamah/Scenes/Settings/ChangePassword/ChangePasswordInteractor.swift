import UIKit

protocol ChangePasswordBusinessLogic {
    func validate(_ changePasswordForm: ChangePasswordForm) -> Bool
    func isCurrentPasswordValid(_ password: String)
}

class ChangePasswordInteractor: ChangePasswordBusinessLogic {
	var presenter: ChangePasswordPresentationLogic?
	var worker = ChangePasswordWorker()

	// MARK: Business logic
    
    func isCurrentPasswordValid(_ password: String) {
        
    }
	
    func validate(_ changePasswordForm: ChangePasswordForm) -> Bool {
        var allFieldsValid = true
        
        if changePasswordForm.currentPassword == nil || changePasswordForm.currentPassword!.count < 4 {
            allFieldsValid = false
            presenter?.presentError(.currentPasswordToShort)
            
        } else if changePasswordForm.newPassword == nil || changePasswordForm.currentPassword!.count < 4 {
            allFieldsValid = false
            presenter?.presentError(.newPasswordToShort)
            
        } else if changePasswordForm.newPassword == nil || changePasswordForm.currentPassword!.count > 30 {
            allFieldsValid = false
            presenter?.presentError(.newPasswordToLong)
        } else if changePasswordForm.confirmPassword != changePasswordForm.newPassword {
            allFieldsValid = false
            presenter?.presentError(.passwordsDontMatch)
        }
        
        return allFieldsValid
    }
}
