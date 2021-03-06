import UIKit

enum WaitType {
    
    case waitSearch(filters: CallDoctorForm)
    case waitAccept(booking: Booking)
    case waitForPayDoctor
    case waitForVisitEnd(booking: Booking)
    
}
