import UIKit
import Alamofire

class ForgotPasswordWorker {
	
    func restoreAccount(withEmail email: String, completion: @escaping ErrorCompletion) {
        
        let params = [
            "email": email
        ]
        
        Alamofire.request(API.User.resetPassword.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default)
            .validate()
            .responseEmpty(completion: completion)
    }
}
