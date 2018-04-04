import UIKit
import Alamofire

class ChangeEmailWorker {
    
    func changeEmail(_ email: String, completion: @escaping ErrorCompletion) {
        
        let params = ["email": email]

        Alamofire.request(API.User.logout.path, method: .post, parameters: params)
            .validate()
            .responseEmpty(completion: completion)
    }
}

