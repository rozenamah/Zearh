import UIKit
import KeychainAccess
import Alamofire
import CoreLocation

typealias BookingCompletion = (Booking?, RMError?) -> Void

class PaymentMethodWorker {
	
    func accept(doctor: User, withPaymentMethod paymentMethod: PaymentMethod, completion: @escaping BookingCompletion) {

        let locationManager = CLLocationManager()
        let location = locationManager.location?.coordinate
        let params: [String: Any] = [
            "doctor": doctor.id,
            "payment": paymentMethod.rawValue,
            "latitude": location?.latitude ?? 0,
            "longitude": location?.longitude ?? 0
        ]
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.request.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseCodable(type: Booking.self, completion: completion)
    }
    
}
