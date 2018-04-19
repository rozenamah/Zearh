import UIKit

class ReportForm {
    var text: String?
    var subject: ReportSubject?
    
    var toParams: [String: Any] {
        let params: [String: Any] = [
            "text": text!,
            "subject": subject!.rawValue
        ]
        return params
    }
}

enum ReportSubject: String, Decodable {
    
    case notArrived = "notArrived"
    case late = "late"
    case misbehave = "misbehaved"
    case other = "other"
    
    static var all: [ReportSubject] {
        return [.notArrived, .late, .misbehave, .other ]
    }
    
    var title: String {
        switch self {
        case .notArrived: return "Doctor did not arrive"
        case .late: return "Doctor was late"
        case .misbehave: return "Doctor was behaving badly"
        case .other: return "Other"
        }
    }
}

