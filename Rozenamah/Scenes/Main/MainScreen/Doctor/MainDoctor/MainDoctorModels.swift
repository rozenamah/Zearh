import UIKit

enum DoctorFlow {
    case accept(visitId: String)
    case reject
    case cancel
    case arrived
}
