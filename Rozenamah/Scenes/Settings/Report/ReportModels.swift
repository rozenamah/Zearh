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
    case test = "test"
    
    static var all: [ReportSubject] {
        return [.test, ]
    }
    
    var title: String {
        switch self {
        case .test: return "test"
        }
    }
}

