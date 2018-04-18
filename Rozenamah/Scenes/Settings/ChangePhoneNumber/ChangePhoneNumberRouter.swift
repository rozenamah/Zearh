import UIKit

class ChangePhoneNumberRouter: Router {
    typealias RoutingViewController = ChangePhoneNumberViewController
    weak var viewController: ChangePhoneNumberViewController?

    // MARK: Routing

    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {

    }

    // MARK: Navigation
    
    func dismissAfterChangedNumber() {
        let alert = UIAlertController(title: "generic.success".localized, message: "settings.changeNumber.numberChanged".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: .default, handler: { [weak self] (action) in
            self?.dismiss()
        }))
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: Passing data

}
