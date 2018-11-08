import UIKit

protocol SplashPresentationLogic {
    func present(user: User)
    func present(error: RMError)
}

class SplashPresenter: SplashPresentationLogic {
	weak var viewController: SplashDisplayLogic?

	// MARK: Presentation logic
	
    func present(user: User) {
        viewController?.userCorrect()
    }
    
    func present(error: RMError) {
        if (error as NSError).code == 0 {
            viewController?.noInternetConnection(error)
            return
        }
        
        switch error {
        case .status(let code, _) where code == .unauthorized:
            viewController?.tokenInvalid()
        case .status(let code, _) where code == .forbidden:
            viewController?.blockedUser()
        default:
            viewController?.handle(error: error)
        }
        
    }
    
}
