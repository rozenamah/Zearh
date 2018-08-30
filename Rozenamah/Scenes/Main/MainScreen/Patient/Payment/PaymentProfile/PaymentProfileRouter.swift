//
//	PaymentProfileRouter.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit

@objc protocol PaymentProfileRoutingLogic {
  func showError(_ error: Error)
  func navigateToPaymentWebViewController()
  func showWaitAlert()
func hideWaitAlert(completion: @escaping () -> ())
}

protocol PaymentProfileDataPassing {
  var dataStore: PaymentProfileDataStore? { get }
}

class PaymentProfileRouter: NSObject, PaymentProfileRoutingLogic, PaymentProfileDataPassing {
  
  // MARK: - Properties
  
  weak var viewController: PaymentProfileViewController?
  var dataStore: PaymentProfileDataStore?
  private var alertLoading: UIAlertController?
  
  // MARK: - Routing
  
  func showError(_ error: Error) {
    
    let alertMessage = UIAlertController(title: "generic.error.ups".localized,
                                         message: error.localizedDescription,
                                         preferredStyle: .alert)
    
    alertMessage.addAction(UIAlertAction(title: "generic.ok".localized, style: .cancel, handler: nil))
    viewController?.present(alertMessage, animated: true, completion: nil)
    
    
  }
  
  func navigateToPaymentWebViewController() {
    guard let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaymentWebViewVC") as? PaymentWebViewViewController,
      var destinationDS = destinationVC.router?.dataStore,
      let viewController = viewController, let dataStore = dataStore else {
        print("Cannot navigate to payment web view controller")
        return
    }
    destinationDS.webViewURL = dataStore.webViewURL
    viewController.navigationController?.pushViewController(destinationVC, animated: true)
  }
  
  func showWaitAlert() {
    alertLoading = showLoadingAlert()
  }
  
    func hideWaitAlert(completion: @escaping () -> ()) {
        alertLoading?.dismiss(animated: true, completion: completion)
    }
  
  private func showLoadingAlert() -> UIAlertController {
    
    let vc = viewController
    
    let alertMessage = UIAlertController(title: nil,
                                         message: "alerts.pleaseWait.pleaseWait".localized,
                                         preferredStyle: .alert)
    
    let indicator = UIActivityIndicatorView()
    indicator.translatesAutoresizingMaskIntoConstraints = false
    alertMessage.view.addSubview(indicator)
    
    let views = ["pending" : alertMessage.view!, "indicator" : indicator]
    var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[indicator]-(-50)-|", options: [], metrics: nil, views: views)
    constraints += NSLayoutConstraint.constraints(withVisualFormat:"H:|[indicator]|", options: [], metrics: nil, views: views)
    alertMessage.view.addConstraints(constraints)
    
    indicator.isUserInteractionEnabled = false
    indicator.startAnimating()
    
    vc?.present(alertMessage, animated: true, completion: nil)
    return alertMessage
  }
  
}
