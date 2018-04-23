import UIKit
import KeychainAccess
import Alamofire

class PaymentMethodWorker {
	
    func accept(doctor: User, withPaymentMethod paymentMethod: PaymentMethod, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "doctor": doctor.id,
            "payment": paymentMethod.rawValue
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.request.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
}
