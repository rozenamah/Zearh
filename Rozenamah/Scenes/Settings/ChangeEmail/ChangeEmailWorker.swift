import UIKit
import Alamofire
import KeychainAccess

class ChangeEmailWorker {
    
    func changeEmail(_ email: EmailForm, completion: @escaping ErrorCompletion) {
        
        let params = email.toParams
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]

        Alamofire.request(API.User.updateProfile.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
}

