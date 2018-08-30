import UIKit

enum PaymentMethod: String, Decodable {
    case card = "card"
    case cash = "cash"
    
    var title: String {
        switch self {
        case .card: return "settings.transactionHistory.byCard".localized
        case .cash: return "settings.transactionHistory.byCash".localized
        }
    }
}
