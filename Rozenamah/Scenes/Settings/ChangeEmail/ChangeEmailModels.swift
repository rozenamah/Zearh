import UIKit

class EmailForm: ParamForm {
    
    var email: String?
    
    var toParams: [String: Any] {
        
        guard let _ = User.current else {
            return [:]
        }
        
        let params = [
            "email": email!
        ]
        return params
    }
}
