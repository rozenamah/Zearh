import UIKit

class DrawerRouter: Router, AppStartRouter {
    typealias RoutingViewController = DrawerViewController
    weak var viewController: DrawerViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "terms_segue":
            let navVC = segue.destination as? UINavigationController
            let termsVC = navVC?.visibleViewController as? TermsViewController
            termsVC?.source = .terms
        case "privacy_segue":
            let navVC = segue.destination as? UINavigationController
            let termsVC = navVC?.visibleViewController as? TermsViewController
            termsVC?.source = .privacyPolicy
        default:
            break
        }
    }

    // MARK: Navigation
    
    func naviagateToEdit() {
        viewController?.toggleLeft()
        viewController?.performSegue(withIdentifier: "edit_profile_segue", sender: nil)
    }
    
    func navigateToPrivacyPolicy() {
        viewController?.toggleLeft()
        viewController?.performSegue(withIdentifier: "privacy_segue", sender: nil)
    }
    
    func navigateToTermsAndConditions() {
        viewController?.toggleLeft()
        viewController?.performSegue(withIdentifier: "terms_segue", sender: nil)
    }
    
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
