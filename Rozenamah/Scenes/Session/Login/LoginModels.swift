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
    
    private enum CodingKeys : String, CodingKey {
        case token, refreshToken = "refresh_token", user
    }
    
    let token: String
    let refreshToken: String
    let user: User
    
}
