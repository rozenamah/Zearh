import UIKit
import Alamofire
import KeychainAccess

typealias UserCompletion = (User?, RMError?) -> Void

class SplashWorker {
    
    func fetchMyBooking(completion: @escaping BookingCompletion) {
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.User.visit.path, method: .get, headers: headers)
            .validate()
            .responseCodable(type: Booking.self, completion: completion)
    }
    
    func fetchMyUser(completion: @escaping UserCompletion) {
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }

        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.User.me.path, method: .get, headers: headers)
            .validate()
            .responseCodable(type: User.self, completion: completion)
    }
}

