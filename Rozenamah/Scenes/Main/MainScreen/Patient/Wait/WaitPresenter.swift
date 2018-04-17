import UIKit

protocol WaitPresentationLogic {
    func handleError(_ error: RMError)
    func presentDoctor(_ user: User)
}

class WaitPresenter: WaitPresentationLogic {
	weak var viewController: WaitDisplayLogic?

	// MARK: Presentation logic
	
    // Called with API calls, depending on response error we can preset different
    // messages
    func handleError(_ error: RMError) {
        switch error {
        default:
            viewController?.handle(error: error)
        }
    }
    
    func presentDoctor(_ user: User) {
        viewController?.found(doctor: user)
    }
}
