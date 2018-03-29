import UIKit
import Alamofire

typealias LoginCompletion = (LoginResponse?, RMError?) -> Void

class LoginWorker {
    
    func login(withForm form: LoginForm, completion: @escaping LoginCompletion) {
        
        let headers = [
            "Authorization": "Basic \(form.base64credentials)"
        ]
        
        Alamofire.request(API.User.login.path, method: .post, headers: headers)
            .validate()
            .responseCodable(type: LoginResponse.self, completion: completion)
    }
    
}

