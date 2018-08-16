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
}

protocol PaymentProfileDataPassing {
    var dataStore: PaymentProfileDataStore? { get }
}

class PaymentProfileRouter: NSObject, PaymentProfileRoutingLogic, PaymentProfileDataPassing {
    
    // MARK: - Properties
    
    weak var viewController: PaymentProfileViewController?
    var dataStore: PaymentProfileDataStore?
    
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
    
}
