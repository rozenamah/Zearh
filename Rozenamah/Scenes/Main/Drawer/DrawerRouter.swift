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
        case "update_to_doctor_segue":
            let navVC = segue.destination as? UINavigationController
            let updateVC = navVC?.visibleViewController as? RegisterDoctorViewController
            updateVC?.registerType = .update
        default:
            break
        }
    }

    // MARK: Navigation
    
    func navigateToCreateDoctorAccount() {
        viewController?.toggleLeft()
        viewController?.performSegue(withIdentifier: "update_to_doctor_segue", sender: nil)
    }
    
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
    
    func navigateToReport() {
        viewController?.toggleLeft()
        viewController?.performSegue(withIdentifier: "report_segue", sender: nil)
    }
    
    func navigateToTransactions() {
        viewController?.toggleLeft()
        viewController?.performSegue(withIdentifier: "transaction_history_segue", sender: nil)
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
