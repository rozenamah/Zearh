import UIKit
import Firebase
import CoreLocation
import Alamofire
import KeychainAccess

class DoctorLocationWorker {
    typealias DoctorLocationCompletion = ((CLLocation?) -> ())
    
    func observeDoctorLocation(for visitId: String, completion: @escaping DoctorLocationCompletion) {
        let ref = Database.database().reference()
        let childRef = ref.child("location/visitId/\(visitId)")
        
        childRef.observe(.value) { (snapshot) in
            if !snapshot.exists() {
                completion(nil)
                return
            }
            // Could be done by Codable protocol
            guard let snapshotDict = snapshot.value as? [String: Double], let latitude = snapshotDict["latitude"], let longitude = snapshotDict["longitude"] else  {
                completion(nil)
                return
            }
            
            let location = CLLocation(latitude: latitude, longitude: longitude)

            completion(location)
        }
    }
    
    func cancelVisit(with visitId: String, completion: @escaping ErrorCompletion) {
        
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
        
        Alamofire.request(API.Visit.cancel.path, method: .post, parameters: params, headers: headers)
        .validate()
        .responseEmpty(completion: completion)
    }
}
