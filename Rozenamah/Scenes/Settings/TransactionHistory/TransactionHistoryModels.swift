import UIKit

enum TimeRange: String {
    case daily = "day"
    case weekly = "week"
    case monthly = "month"
    case total = "total"
}

class TransactionHistory: Decodable {
    
    let cost: Int
    let count: Int
    let visits: [Booking]
    
}

class TransactionHistoryBuilder: ParamForm {
    
    var page: Int = 0
    var limit: Int = 10
    var range: TimeRange = .weekly
    var userType: UserType!
    
    var toParams: [String : Any] {
        return [
            "page": page,
            "limit": limit,
            "user_type": userType.rawValue,
            "range": range.rawValue
        ]
    }
}
