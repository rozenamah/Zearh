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
                return "You need to choose your subject"
            case .messageMissing:
                return "You need to write your description"
            case .unknown:
                return "Report was not sent due to an error"
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
