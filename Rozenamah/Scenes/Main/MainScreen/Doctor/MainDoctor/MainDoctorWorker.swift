import UIKit
import Alamofire
import KeychainAccess

class MainDoctorWorker {
	
    func updateAvabilityTo(_ availbility: Bool, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "available": availbility
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Doctor.availability.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
        
        
    }
    
}
