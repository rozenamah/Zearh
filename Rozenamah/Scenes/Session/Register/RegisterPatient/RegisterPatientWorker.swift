import UIKit
import Alamofire

class RegisterPatientWorker {
    
    func verifyIfEmailTaken(_ email: String, completion: @escaping ErrorCompletion) {
        
        let params = [
            "email": email
        ]
        
        Alamofire.request(API.User.verifyEmail.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default)
            .validate()
            .responseEmpty(completion: completion)
    }
    
    func verifyIfPhoneTaken(_ phone: String, completion: @escaping ErrorCompletion) {
        
        let params = [
            "phone": phone
        ]
        
        Alamofire.request(API.User.verifyPhone.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default)
            .validate()
            .responseEmpty(completion: completion)
    }
    
    
    func register(withForm form: ParamForm, completion: @escaping LoginCompletion) {
        
        let params = form.toParams
        
        Alamofire.request(API.User.register.path, method: .post, parameters: params,
            encoding: JSONEncoding.default)
            .validate()
            .responseCodable(type: LoginResponse.self, completion: completion)
    }
    
}
