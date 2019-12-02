import UIKit

enum DoctorFlow {
    case accepted(booking: Booking)
    case cancel
    case arrived(booking: Booking)
    case ended
    case noLocation
    case noPushPermission
}
