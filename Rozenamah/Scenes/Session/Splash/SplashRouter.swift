import UIKit

func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

class SplashRouter: Router, AppStartRouter, AlertRouter {
    
    typealias RoutingViewController = SplashViewController
    weak var viewController: SplashViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func showUserBlocked() {
        let alert = UIAlertController(title: "Ups", message: "This user is blocked", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.navigateToSignUp()
        }))
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func navigateToAppWithDelay() {
        delayWithSeconds(1.5) {
            self.navigateToDefaultApp()
        }
    }
    
    func navigateToSignUpWithDelay() {
        delayWithSeconds(2.5) {
            self.navigateToSignUp()
        }
    }

    // MARK: Passing data

}
