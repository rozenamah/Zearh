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
    var type: String
    var avatar: UIImage?
    
    init(user: User) {
        self.name = user.name
        self.surname = user.surname
        self.type = user.type.rawValue
        // TODO: Init doctor data
    }
    
    var toParams: [String: Any] {
        var params: [String: Any] = [
            "name": name,
            "surname": surname
        ]
        if let doctor = doctor {
            params["classification"] = doctor.classification.rawValue
           
            if let specialization = doctor.specialization {
                 params["specialization"] = specialization.rawValue
            }
            
            if let price = doctor.price {
                params["price"] = price
            }
        }
       
        return params
    }
    
    var toAvatarParams: [String: Any] {
        var avatarParams: [String: Any] = [:]
        if let avatar = avatar {
            let imageData: Data = UIImageJPEGRepresentation(avatar, 0.9)!
            avatarParams["avatar"] = "data:image/jpeg;base64,\(imageData.base64EncodedString())"
        }
        return avatarParams
    }
    
}

