import UIKit

class LocationAlertRouter: Router {
    typealias RoutingViewController = LocationAlertViewController
    weak var viewController: LocationAlertViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func navigateToSettings() {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
    }

    // MARK: Passing data

}
