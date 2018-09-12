import UIKit
import Alamofire
import KeychainAccess

class RegisterDoctorWorker: RegisterPatientWorker {
	
    func updateUser(withForm form: ParamForm, completion: @escaping UserCompletion) {
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        var params = form.toParams
        if let index = params.index(where: {$0.key == "lang"}) {
            params.remove(at: index)
        }
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Patient.upgrade.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseCodable(type: User.self, completion: completion)
    }
    
}
