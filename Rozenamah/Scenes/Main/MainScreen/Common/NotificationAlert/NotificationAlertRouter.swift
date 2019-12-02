import UIKit

class NotificationAlertRouter: Router {
    typealias RoutingViewController = NotificationAlertViewController
    weak var viewController: NotificationAlertViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation

    func navigateToSettings() {
        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
    }

    // MARK: Passing data

}
