import UIKit
import CoreLocation

enum PatientFlow {
    case pending
    case callDoctor
    case searchWith(filters: CallDoctorForm)
    case accept(doctor: VisitDetails, foundByFilters: CallDoctorForm)
    case waitForAccept(booking: Booking)
    case doctorLocation(location: CLLocation)
    case visitConfirmed(booking: Booking)
}

struct Location: Decodable {
    let latitude: Double
    let longitude: Double
    
    var toCLCoordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
