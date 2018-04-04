import UIKit
import Alamofire

class ChangePasswordWorker {
    
    func changePassword(_ changePasswordForm: ChangePasswordForm, completion: @escaping ErrorCompletion) {
        let params  =
        ["password": changePasswordForm.currentPassword!,
         "newPassword": changePasswordForm.newPassword!,
         "confirmPassword": changePasswordForm.confirmPassword!
        ]
        
  
        Alamofire.request(API.User.resetPassword.path, method: .post, parameters: params)
            .validate()
            .responseEmpty(completion: completion)
    }
}
