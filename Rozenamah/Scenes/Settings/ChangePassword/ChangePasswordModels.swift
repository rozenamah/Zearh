import UIKit

class ChangePasswordForm {
    var currentPassword: String?
    var newPassword: String?
    var confirmPassword: String?
    
    var toParams: [String: Any] {
        
        let params = [
            "old_password": currentPassword!,
            "new_password": newPassword!
        ]
        return params
    }
}
