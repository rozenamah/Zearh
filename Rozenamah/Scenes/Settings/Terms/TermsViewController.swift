//
//  TermsViewController.swift
//  Rozenamah
//
//  Created by Dominik Majda on 19.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import Localize

class TermsViewController: UIViewController {

    enum TermsType {
        case terms
        case privacyPolicy
    }
    
    // MARK: Outlets
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    /// Depending on this value we display
    var source: TermsType!
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        let localize = Localize.shared
        var privacy: URL
        var terms: URL
        
        if localize.currentLanguage == "ar" {
           privacy = URL(string: "https://zearh-api.rozenamah.com/documents/service-provider?lang=ar")!
           terms = URL(string: "https://zearh-api.rozenamah.com/documents/terms?lang=ar")!
        } else {
            privacy = URL(string: "https://zearh-api.rozenamah.com/documents/service-provider?lang=en")!
            terms = URL(string: "https://zearh-api.rozenamah.com/documents/terms?lang=en")!
        }
        
        switch source! {
        case .privacyPolicy:
            title = "menu.privacyPolicy".localized
            webView.loadRequest(URLRequest(url: privacy))
        case .terms:
            title = "menu.termsConditions".localized
            webView.loadRequest(URLRequest(url: terms))
        }
    }
    
    // MARK: - Event handling
    
    @IBAction func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension TermsViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
}
