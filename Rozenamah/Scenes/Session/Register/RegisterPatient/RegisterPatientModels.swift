import UIKit

/// Depending on it we can start registration as doctor or patient
enum RegisterMode {
    case patient
    case doctor
}

class RegisterForm {
    var password: String?
    var email: String?
    var repeatPassword: String?
    var name: String?
    var surname: String?
    var avatar: UIImage?
    
    var toParams: [String: Any] {
        return [
            "email": email!,
            "password": password!,
            "name": name!,
            "surname": surname!
        ]
    }
    
}
