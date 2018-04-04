import UIKit
import Alamofire
import KeychainAccess

class EditProfileWorker {
    func editUserProfile(profileForm: EditProfileForm, completion: @escaping LoginCompletion) {
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let params = profileForm.toParams
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.User.updateProfile.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: LoginResponse.self , completion: completion)
    }
}
