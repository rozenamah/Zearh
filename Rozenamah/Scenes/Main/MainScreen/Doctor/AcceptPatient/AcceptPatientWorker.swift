import UIKit
import KeychainAccess
import Alamofire

class AcceptPatientWorker {
    
    func acceptPatient(for booking: Booking, completion: @escaping BookingCompletion) {
        //TODO: Change to booking completion when data is available from API
        let params: [String: Any] = [
            "visit": booking.id
        ]
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.accept.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseCodable(type: Booking.self, completion: completion)
    }
    
    func rejectPatient(for booking: Booking, completion: @escaping BookingCompletion) {
        
        let params: [String: Any] = [
            "visit": booking.id
        ]
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.reject.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseCodable(type: Booking.self, completion: completion)
    }
}
