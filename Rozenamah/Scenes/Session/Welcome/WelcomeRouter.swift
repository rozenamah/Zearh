import UIKit

class WelcomeRouter: Router {
    typealias RoutingViewController = WelcomeViewController
    weak var viewController: WelcomeViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case "register_doctor_segue":
            let createAccountVC = segue.destination as? RegisterPatientViewController
            createAccountVC?.registrationMode = .doctor
        default:
            break
        }
    }

    // MARK: Navigation

    // MARK: Passing data

}
