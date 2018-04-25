import UIKit
import FirebaseDatabase
import CoreLocation
import KeychainAccess
import Alamofire

class DoctorOnTheWayWorker: DoctorLocationWorker {
    
    func updateLocationInDataBase(_ location: CLLocation) {
        
        guard let user = User.current else {
            return
        }
        
        let ref = Database.database().reference().child("location/user/\(user.id)")
        let locationUpdate: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.latitude
        ]
        
        ref.updateChildValues(locationUpdate)
        
    }
    
    func doctorArrived(for visitId: String, completion: @escaping ErrorCompletion) {
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = [
            "visit": visitId
        ]
        
        Alamofire.request(API.Doctor.arrived.path, method: .post, parameters: params, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
}
