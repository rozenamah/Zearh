import UIKit

class LoginForm {
    var password: String?
    var email: String?
    
    var base64credentials: String {
        guard let password = password, let email = email else {
            return ""
        }
        
        let credentialData = "\(email):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        return base64Credentials
    }
    
}

class LoginResponse: Decodable {
    
    let token: String
    let user: User
    
}
