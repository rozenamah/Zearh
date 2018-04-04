import UIKit

class EmailForm {
    
    var email: String?
    
    var toParams: [String: Any] {
        
        guard let user = User.current else {
            return [:]
        }
        
        let params = [
            "email": email!,
            "type": user.type.rawValue
        ]
        return params
    }
}
