import UIKit
import Alamofire
import KeychainAccess
import CoreLocation

class MainDoctorWorker {
    
    func acceptPatient(for visitId: String, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "visit": visitId
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.accept.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
    func rejectPatient(for visitId: String, completion: @escaping ErrorCompletion) {
        
        let params: [String: Any] = [
            "visit": visitId
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Visit.reject.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
	
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
    func updateLocation(to location: CLLocation, completion: @escaping ErrorCompletion) -> DataRequest? {
        
        let params: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
        ]
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return nil
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        return Alamofire.request(API.Doctor.position.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
}
