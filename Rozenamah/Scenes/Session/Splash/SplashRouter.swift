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
        let alert = UIAlertController(title: "generic.error.ups".localized, message: "session.splash.userBlocked".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.confirm.ok".localized, style: .default, handler: { (_) in
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
