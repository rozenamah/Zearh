import UIKit
import FirebaseDatabase
import CoreLocation

class BusyDoctorWorker {
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
}
