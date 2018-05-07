import UIKit
import FirebaseDatabase
import CoreLocation
import KeychainAccess
import Alamofire

class DoctorOnTheWayWorker: DoctorLocationWorker {
    
    func updateLocationInDatabase(_ location: CLLocation, booking: Booking) {
  
        let ref = Database.database().reference().child("location/booking/\(booking.id)")
        let locationUpdate: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.latitude
        ]
        
        ref.updateChildValues(locationUpdate)
        
    }
    
    func doctorArrived(for booking: Booking, completion: @escaping ErrorCompletion) {
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
        
        Alamofire.request(API.Doctor.arrived.path, method: .post, parameters: params,
                          encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseEmpty(completion: completion)
    }
}
