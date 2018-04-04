import UIKit
import Alamofire
import KeychainAccess

class ChangePasswordWorker {
    
    func changePassword(_ changePasswordForm: ChangePasswordForm, completion: @escaping ErrorCompletion) {

        let params = changePasswordForm.toParams
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
  
        Alamofire.request(API.User.changePassword.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
}
