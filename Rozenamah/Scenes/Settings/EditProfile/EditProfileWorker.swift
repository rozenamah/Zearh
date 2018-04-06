import UIKit
import Alamofire
import KeychainAccess

class EditProfileWorker {
    
    func editUserProfile(profileForm: ParamForm, completion: @escaping UserCompletion) {
        
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
            .responseCodable(type: User.self , completion: completion)
    }
    
    func editUserAvatar(_ profileForm: EditProfileForm, completion: @escaping UserCompletion) {
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let params = profileForm.toAvatarParams
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.User.updateAvatar.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: User.self , completion: completion)
    }
    
}
