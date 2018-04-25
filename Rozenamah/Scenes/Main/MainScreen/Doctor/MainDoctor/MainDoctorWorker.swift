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
            .responseEmpty(completion: { (error) in
                User.current?.doctor?.isAvailable = availbility
                completion(error)
            })
                
        
    }
    
    @discardableResult
    func updateLocation(to location: CLLocation? = nil, completion: @escaping ErrorCompletion) -> DataRequest? {
        
        var params: [String: Any]
        
        if let location = location {
            params = [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude,
            ]
        } else {
            params = [:]
        }
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return nil
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let method: HTTPMethod = location == nil ? .delete : .post
        
        return Alamofire.request(API.Doctor.position.path, method: method, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
}
