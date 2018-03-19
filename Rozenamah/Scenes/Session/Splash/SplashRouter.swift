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
    
    func navigateToAppWithDelay() {
        delayWithSeconds(1.5) {
            self.navigateToApp()
        }
    }
    
    func navigateToSignUpWithDelay() {
        delayWithSeconds(2.5) {
            self.navigateToSignUp()
        }
    }

    // MARK: Passing data

}
