import UIKit

protocol SplashBusinessLogic {
    func fetchUserData()
}

class SplashInteractor: SplashBusinessLogic {
	var presenter: SplashPresentationLogic?
	var worker = SplashWorker()

	// MARK: Business logic
	
    func fetchUserData() {
        worker.fetchMyUser { (user, error) in
            if let error = error {
                self.presenter?.present(error: error)
                return
            }
            
            if let user = user {
                // Save user in current
                User.current = user
                
                self.presenter?.present(user: user)
            }
        }
    }
}
