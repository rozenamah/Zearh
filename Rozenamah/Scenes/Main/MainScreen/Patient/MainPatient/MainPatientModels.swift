import UIKit
import CoreLocation

enum PatientFlow {
    case pending
    case callDoctor
    case searchWith(filters: CallDoctorForm)
    case accept(doctor: VisitDetails, foundByFilters: CallDoctorForm)
    case waitForAccept(booking: Booking)
    case cancel
    case doctorLocation(location: CLLocation)
}
