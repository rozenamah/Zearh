import UIKit

class Transaction: Decodable {
    var visit: Visit
    var user: User
    var dateTimestamp: Double
    var arrivalTimestamp: Double
    var leaveTimestamp: Double
    var paymentMethod: PaymentMethod
}

enum TimeRange {
    case daily
    case weekly
    case monthly
    case total
}

