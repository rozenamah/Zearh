import UIKit

class Transaction: Decodable {
    var visit: Visit
    var user: User
    var dateTimestamp: Double
    var arrivalTimestamp: Double
    var leaveTimestamp: Double
    var paymentMethod: PaymentMethod
}

enum DateFormat: String {
    case hour = "HH:mm"
    case date = "yyyy-MM-dd"
}

