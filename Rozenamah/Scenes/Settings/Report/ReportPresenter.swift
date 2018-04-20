import UIKit

protocol ReportPresentationLogic {
    func reportSent()
    func presentError(_ error: ReportPresenter.ReportError)
}

class ReportPresenter: ReportPresentationLogic {
	weak var viewController: ReportDisplayLogic?

	// MARK: Presentation logic
	
    enum ReportError: LocalizedError {
        case subjectMissing
        case messageMissing
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .subjectMissing:
                return "settings.report.error.subjectMissing".localized
            case .messageMissing:
                return "settings.report.error.messageMissing".localized
            case .unknown:
                return "settings.report.error.unknown".localized
            }
        }
    }
   
    func presentError(_ error: ReportPresenter.ReportError) {
        switch error {
        case .subjectMissing:
            viewController?.handle(error: error, inField: .subject)
        case .messageMissing:
            viewController?.handle(error: error, inField: .field)
        case .unknown:
            viewController?.handle(error: error, inField: .unknown)
        }
    }
    
    func reportSent() {
        
    }
    
}
