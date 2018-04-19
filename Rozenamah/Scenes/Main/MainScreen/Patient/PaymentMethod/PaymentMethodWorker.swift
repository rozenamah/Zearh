import UIKit
import KeychainAccess
import Alamofire

class PaymentMethodWorker {
	
    func accept(doctor: User, withPaymentMethod paymentMethod: PaymentMethod, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "uid": doctor.id,
            "payment": paymentMethod.rawValue
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Doctor.accept.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
}
