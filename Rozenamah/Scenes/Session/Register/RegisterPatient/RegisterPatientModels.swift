import UIKit

/// Depending on it we can start registration as doctor or patient
enum RegisterMode {
    case patient
    case doctor
}

class RegisterForm: ParamForm {
    var password: String?
    var email: String?
    var repeatPassword: String?
    var name: String?
    var surname: String?
    var avatar: UIImage?
    
    var toParams: [String: Any] {
        
        
        var params = [
            "type": "patient",
            "email": email!,
            "password": password!,
            "name": name!,
            "surname": surname!
        ]
        
        if let avatar = avatar {
            let imageData: Data = UIImageJPEGRepresentation(avatar, 0.9)!
            params["avatar"] = "data:image/jpeg;base64,\(imageData.base64EncodedString())"
        }
        
        return params
    }
    
}
