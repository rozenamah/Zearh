import UIKit

class ReportForm {
    var text: String?
    var subject: ReportSubject?
    
    var toParams: [String: Any] {
        let params: [String: Any] = [
            "message": text!,
            "type": subject!.rawValue
        ]
        return params
    }
}

enum ReportSubject: String, Decodable {
    
    case bug = "bug"
    case user = "user"
    case refund = "refund"
    case opinion = "opinion"
    
    static var all: [ReportSubject] {
        return [.bug, .user, .refund, .opinion, ]
    }
    
    var title: String {
        switch self {
        case .bug: return "settings.report.reportTopic.bug".localized
        case .user: return "settings.report.reportTopic.user".localized
        case .refund: return "settings.report.reportTopic.refund".localized
        case .opinion: return "settings.report.reportTopic.opinion".localized
        }
    }
}

