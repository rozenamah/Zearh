import UIKit

enum PaymentMethod: String, Decodable {
    case card = "card"
    case cash = "cash"
    
    var title: String {
        switch self {
        case .card:
            return "By card"
        case .cash:
            return "By cash"
        }
    }
}
