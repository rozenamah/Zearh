import UIKit
import Alamofire
import KeychainAccess

class ChangePasswordWorker {
    
    func changePassword(_ changePasswordForm: ChangePasswordForm, completion: @escaping LoginCompletion) {

        let params = changePasswordForm.toParams
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
  
        Alamofire.request(API.User.changePassword.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: LoginResponse.self , completion: completion)
    
    }
}
