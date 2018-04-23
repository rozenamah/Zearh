import UIKit
import KeychainAccess
import Alamofire

typealias BookingCompletion = (Booking?, RMError?) -> Void

class PaymentMethodWorker {
	
    func accept(doctor: User, withPaymentMethod paymentMethod: PaymentMethod, completion: @escaping BookingCompletion) {
        
        let params: [String: Any] = [
            "doctor": doctor.id,
            "payment": paymentMethod.rawValue
        ]
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.request.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: Booking.self, completion: completion)
    }
    
}
