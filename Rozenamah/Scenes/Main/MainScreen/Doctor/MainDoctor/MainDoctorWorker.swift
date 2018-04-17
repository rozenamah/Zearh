import UIKit
import Alamofire
import KeychainAccess
import CoreLocation

class MainDoctorWorker {
	
    func updateAvabilityTo(_ availbility: Bool, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "available": availbility
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Doctor.availability.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
    func updateLocation(to location: CLLocation, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Doctor.position.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
}
