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
    case wrongDiagnose = "wrongDiagnose"
    case other = "other"
    
    static var all: [ReportSubject] {
        return [.notArrived, .late, .misbehave, .wrongDiagnose, .other ]
    }
    
    var title: String {
        switch self {
        case .notArrived: return "settings.report.reportTopic.notArrived".localized
        case .late: return "settings.report.reportTopic.late".localized
        case .misbehave: return "settings.report.reportTopic.misbehave".localized
        case .wrongDiagnose: return "settings.report.reportTopic.wrongDiagnose".localized
        case .other: return "settings.report.reportTopic.other".localized
        }
    }
}

