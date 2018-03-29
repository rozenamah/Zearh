import UIKit

class EditProfileForm {
    
    class DoctorEditProfileForm {
        var classification: Classification
        var specialization: DoctorSpecialization?
        var price: Int?
        
        init(user: User) {
            classification = .consultants
            price = 100
        }
    }
    
    var doctor: DoctorEditProfileForm?
    var name: String
    var surname: String
    
    init(user: User) {
        self.name = user.name
        self.surname = user.surname
        
        // TODO: Init doctor data
    }
}

