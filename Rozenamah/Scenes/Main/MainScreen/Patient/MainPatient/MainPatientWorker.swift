import UIKit
import KeychainAccess
import Alamofire
import CoreLocation

typealias LocationsCompletion = ([Location]?, RMError?) -> Void

class MainPatientWorker {
	
    func fetchDoctors(nearby location: CLLocation, completion: @escaping LocationsCompletion) {
        
        let params = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
        ]
        
        guard let token = Keychain.shared.token else {
            completion(nil, RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        Alamofire.request(API.Doctor.nearby.path, method: .get, parameters: params, headers: headers)
            .validate()
            .responseCodable(type: [Location].self, completion: completion)
    }
    

}
