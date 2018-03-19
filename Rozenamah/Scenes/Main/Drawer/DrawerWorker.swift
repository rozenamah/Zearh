import UIKit
import Alamofire
import KeychainAccess

typealias ErrorCompletion = (RMError?) -> Void

class DrawerWorker {
	
    func logout(completion: @escaping ErrorCompletion) {
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.logout.path, method: .post, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
        
    }
    
}
