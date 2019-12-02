import UIKit
import Alamofire

typealias LoginCompletion = (LoginResponse?, RMError?) -> Void

class LoginWorker {
    
    func login(withForm form: LoginForm, completion: @escaping LoginCompletion) {
        
        
        print(form.base64credentials)
        let headers = [
            "Authorization": "Basic \(form.base64credentials)"
        ]
        
        Alamofire.request(API.User.login.path, method: .post,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseCodable(type: LoginResponse.self, completion: completion)
     
    }
    
}

