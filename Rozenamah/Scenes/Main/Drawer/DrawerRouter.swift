import UIKit

class DrawerRouter: Router, AppStartRouter {
    typealias RoutingViewController = DrawerViewController
    weak var viewController: DrawerViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to log out a user?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.viewController?.loginCofirmed()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }

    // MARK: Passing data

}
