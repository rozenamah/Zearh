import UIKit
import Alamofire
import KeychainAccess

class EndVisitWorker {
	
    func endVisit(for booking: Booking, completion: @escaping BookingCompletion) {
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = [
            "visit": booking.id
        ]
        
        Alamofire.request(API.Visit.end.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseCodable(type: Booking.self, completion: completion)
    }
}
