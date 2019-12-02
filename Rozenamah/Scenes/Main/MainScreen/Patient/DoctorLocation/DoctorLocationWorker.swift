import UIKit
import Firebase
import CoreLocation
import Alamofire
import KeychainAccess

class DoctorLocationWorker {
    typealias DoctorLocationCompletion = ((CLLocation?) -> ())
    private var locationObserver: DatabaseObserver?
    
    func observeDoctorLocation(for booking: Booking, completion: @escaping DoctorLocationCompletion) {
        let ref = Database.database().reference()
        let childRef = ref.child("booking/\(booking.id)")
        
        let locationHandle = childRef.observe(.value) { (snapshot) in
            if !snapshot.exists() {
                completion(nil)
                return
            }
            // Could be done by Codable protocol
            guard let snapshotDict = snapshot.value as? [String: Double],
                let json =  try? JSONEncoder().encode(snapshotDict), let location = try? JSONDecoder().decode(Location.self, from: json) else  {
                    completion(nil)
                    return
            }
            completion(CLLocation(latitude: location.latitude,
                                  longitude: location.longitude))
        }
        
        locationObserver = DatabaseObserver(ref: ref, handle: locationHandle)
    }
    
    func cancelVisit(with booking: Booking, completion: @escaping ErrorCompletion) {
        
        guard let token = Keychain.shared.token else {
            completion(RMError.tokenDoesntExist)
            return
        }
        
        let headers = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = [
            "visit": booking.id
        ]
        
        Alamofire.request(API.Visit.cancel.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
    
    func stopObservingDoctorLocation() {
        locationObserver?.remove()
    }
}
