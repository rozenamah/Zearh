//
//  TermsViewController.swift
//  Rozenamah
//
//  Created by Dominik Majda on 19.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {

    enum TermsType {
        case terms
        case privacyPolicy
    }
    
    // MARK: Outlets
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Properties
    
    /// Depending on this value we display
    var source: TermsType!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        switch source! {
        case .privacyPolicy:
            title = "menu.privacyPolicy".localized
            webView.loadRequest(URLRequest(url: URL(string: "https://www.google.com")!))
        case .terms:
            title = "menu.termsConditions".localized
            webView.loadRequest(URLRequest(url: URL(string: "https://www.google.com")!))
        }
    }
    
    // MARK: - Event handling
    
    @IBAction func dismissAction() {
        dismiss(animated: true, completion: nil)
    }


}
