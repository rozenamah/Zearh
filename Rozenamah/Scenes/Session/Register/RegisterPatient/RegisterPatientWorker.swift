import UIKit
import Alamofire

class RegisterPatientWorker {
    
    func register(withForm form: RegisterForm, completion: @escaping LoginCompletion) {
        
        let params = form.toParams
        
        Alamofire.request(API.register.path, method: .post, parameters: params)
            .validate()
            .responseCodable(type: LoginResponse.self, completion: completion)
    }
    
}
