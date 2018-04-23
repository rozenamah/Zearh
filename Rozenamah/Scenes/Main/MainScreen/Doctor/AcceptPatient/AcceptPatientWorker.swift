import UIKit
import KeychainAccess
import Alamofire

class AcceptPatientWorker {
    
    func acceptPatient(for visitId: String, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "visit": visitId
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.accept.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
    func rejectPatient(for visitId: String, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "visit": visitId
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.reject.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
}
