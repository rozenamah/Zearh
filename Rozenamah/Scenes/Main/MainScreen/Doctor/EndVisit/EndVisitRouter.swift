import UIKit

class EndVisitRouter: Router, AlertRouter {
    typealias RoutingViewController = EndVisitViewController
    weak var viewController: EndVisitViewController?

    /// Alert view, displayed when ending visit
    private var alertLoading: UIAlertController?
    
    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showWaitAlert() {
        alertLoading = showLoadingAlert()
    }
    
    func hideWaitAlert(completion: (() -> Void)? = nil) {
        alertLoading?.dismiss(animated: true, completion: completion)
    }
    
    // MARK: Passing data

}
