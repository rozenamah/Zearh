import UIKit

enum DoctorFlow {
    case accepted(booking: Booking)
    case rejected
    case cancel
    case arrived(booking: Booking)
}
