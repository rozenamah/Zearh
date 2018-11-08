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
                
                // Now check if user has any pending booking
                self.worker.fetchMyBooking(completion: { (booking, error) in
                    
                    // Save launch booking in app delegate
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.launchBooking = booking
                    }
                    
                    self.presenter?.present(user: user)
                })
            }
            
            
        }
    }
}
