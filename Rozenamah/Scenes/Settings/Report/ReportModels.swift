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
    case other = "other"
    
    static var all: [ReportSubject] {
        return [.bug, .user, .refund, .opinion, .other ]
    }
    
    var title: String {
        switch self {
        case .bug: return "settings.report.reportTopic.notArrived".localized
        case .user: return "settings.report.reportTopic.late".localized
        case .refund: return "settings.report.reportTopic.misbehave".localized
        case .opinion: return "settings.report.reportTopic.wrongDiagnose".localized
        case .other: return "settings.report.reportTopic.other".localized
        }
    }
}

