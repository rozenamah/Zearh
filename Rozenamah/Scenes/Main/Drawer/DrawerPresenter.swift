import UIKit

protocol DrawerPresentationLogic {
    func presentLogoutSuccess()
}

class DrawerPresenter: DrawerPresentationLogic {
	weak var viewController: DrawerDisplayLogic?

	// MARK: Presentation logic
    
    func presentLogoutSuccess() {
        viewController?.logoutSuccess()
    }
	
}
