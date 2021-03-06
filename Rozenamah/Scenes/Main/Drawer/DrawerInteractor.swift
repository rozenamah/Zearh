import UIKit
import KeychainAccess

protocol DrawerBusinessLogic {
    func stopReceivingRequests() 
    func logout()
}

class DrawerInteractor: DrawerBusinessLogic {
	var presenter: DrawerPresentationLogic?
	var worker = DrawerWorker()

	// MARK: Business logic
    
    func logout() {
        worker.logout { (error) in
            // Logout anyway if errorm remove tokensafa
            Keychain.shared.token = nil
            // Remove all firebase observers
            DatabaseObserver.removeAll()
            self.presenter?.presentLogoutSuccess()
        }
    }
	
    func stopReceivingRequests() {
        MainDoctorWorker().updateAvabilityTo(false) { [weak self] (error) in
            // Do nothing
        }
    }
}
