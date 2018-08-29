import UIKit
import Alamofire
import KeychainAccess


class PaymentWorker {
	
    typealias PaymentCompletion = (Payment.Details?, RMError?) -> Void
    
    func fetchPaymentProfile(completion: @escaping PaymentCompletion) {
        
        guard let token = Keychain.shared.token else {
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]

        Alamofire.request(API.Payments.paypage.path, method: .get, headers: headers)
            .validate()
            .responseCodable(type: Payment.Details.self, completion: completion)
    }
    
}
