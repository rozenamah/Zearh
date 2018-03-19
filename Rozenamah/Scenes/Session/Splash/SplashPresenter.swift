import UIKit

protocol SplashPresentationLogic {
    func present(user: User)
    func present(error: RMError)
}

class SplashPresenter: SplashPresentationLogic {
	weak var viewController: SplashDisplayLogic?

	// MARK: Presentation logic
	
    func present(user: User) {
        // TODO: BLOCKED USER
        viewController?.userCorrect()
    }
    
    func present(error: RMError) {
        switch error {
        case .status(let code, _) where code == .unauthorized:
            viewController?.tokenInvalid()
        default:
            viewController?.handle(error: error)
        }
        
    }
    
}
