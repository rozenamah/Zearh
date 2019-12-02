import UIKit

class LoginForm {
    var password: String?
    var login: String?
    
    
    var toParams: [String: Any] {
        var params = [String: Any]()
        params["email"] = login!
        params["password"] = password!
        return params
    }
    
    var base64credentials: String {
        guard let password = password, let email = login else {
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
