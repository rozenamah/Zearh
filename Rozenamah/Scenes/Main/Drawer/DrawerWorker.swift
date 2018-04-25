import UIKit
import Alamofire
import KeychainAccess

typealias ErrorCompletion = (RMError?) -> Void

class DrawerWorker {
	
    func logout(completion: @escaping ErrorCompletion) {
        
        var params: [String: Any] = [:]
        if let deviceToken = Settings.shared.deviceToken {
            params["device_token"] = deviceToken
        }
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.User.logout.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
        
    }
    
}
