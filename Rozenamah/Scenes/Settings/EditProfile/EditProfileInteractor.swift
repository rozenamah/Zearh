import UIKit
import KeychainAccess

protocol EditProfileBusinessLogic {
    func updateUserInfo(_ editProfile: EditProfileForm)
    func updateUserAvatar(_ editProfile: EditProfileForm)
    func validate(_ editProfile: EditProfileForm) -> Bool
    func deleteAccount()
}

class EditProfileInteractor: EditProfileBusinessLogic {
	var presenter: EditProfilePresentationLogic?
	var worker = EditProfileWorker()

	// MARK: Business logic
	
    func deleteAccount() {
        worker.deleteAccount { (error) in
            // Logout anyway if errorm remove token
            Keychain.shared.token = nil
            // Remove all firebase observers
            DatabaseObserver.removeAll()
            self.presenter?.presentDeleteSuccess()
        }
    }
    
    func updateUserInfo(_ editProfile: EditProfileForm) {
        worker.editUserProfile(profileForm: editProfile) { (response,error)  in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            if let response = response {
                // Save user in current
                User.current = response
                
                self.presenter?.profileUpdated()
            }
            
        }
    }
    
    func updateUserAvatar(_ editProfile: EditProfileForm) {
        worker.editUserAvatar(editProfile) { (response, error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            
            if let response = response {
                // Save user in current
                User.current = response
                
                self.presenter?.profileUpdated()
            }
        }
    }
    
    func validate(_ editProfile: EditProfileForm) -> Bool {
        var allFieldsValid = true
        
        let name = editProfile.name
        let surname = editProfile.surname
        
        // Name verification
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
        
        // Surname verification
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
        
        // Doctor verification
        var doctorValid = true
        if let doctor = editProfile.doctor {
            doctorValid = validateDoctor(doctor)
        }
        return allFieldsValid && doctorValid
    }
    
    private func validateDoctor(_ doctor: EditProfileForm.DoctorEditProfileForm) -> Bool {
        var allFieldsValid = true
        
        // Specialization verification
        if (doctor.classification == .consultants ||
            doctor.classification == .specialist),
            doctor.specialization == nil  {
            
            allFieldsValid = false
            presenter?.presentError(.specializationMissing)
        }
        
        // Price verification
        if doctor.price == nil || doctor.price! > 1000000 {
            
            allFieldsValid = false
            presenter?.presentError(.priceMissing)
        }
        
        return allFieldsValid
    }
}
