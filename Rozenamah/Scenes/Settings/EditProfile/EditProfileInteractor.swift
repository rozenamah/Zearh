import UIKit
import KeychainAccess

protocol EditProfileBusinessLogic {
    func updateUserInfo(_ editProfile: EditProfileForm)
}

class EditProfileInteractor: EditProfileBusinessLogic {
	var presenter: EditProfilePresentationLogic?
	var worker = EditProfileWorker()

	// MARK: Business logic
	
    func updateUserInfo(_ editProfile: EditProfileForm) {
        worker.editUserProfile(profileForm: editProfile) { (response,error)  in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            if let response = response {
                // Save token in keychain
                Keychain.shared.token = response.token
                
                // Save user in current
                User.current = response.user
                
                self.presenter?.profileUpdated()
            }
            
        }
    }
}
