//
//	PaymentWebViewViewController.swift
//	Rozenamah
//
//	Created by Kamil Zajac on 14.08.2018.
//	Copyright (c) 2018 Dominik Majda. All rights reserved.
//

import UIKit
import WebKit

protocol PaymentWebViewDisplayLogic: class {}

class PaymentWebViewViewController: UIViewController, PaymentWebViewDisplayLogic {
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: - Properties
    
    var interactor: PaymentWebViewBusinessLogic?
    var router: (NSObjectProtocol & PaymentWebViewRoutingLogic & PaymentWebViewDataPassing)?
    private var isLoadingAlertVisible = false
    
    // MARK: - Initialization
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = PaymentWebViewInteractor()
        let presenter = PaymentWebViewPresenter()
        let router = PaymentWebViewRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        loadWebView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(for:)), name: MainPatientRouter.kVisitRequestNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: MainPatientRouter.kVisitRequestNotification, object: nil)
    }
    
    // MARK: - Private
    
    @objc private func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["booking"] as? Booking,
            booking.patient == User.current, booking.status == .accepted {
            router?.dismissLoadingAlert(completion: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    private func loadWebView() {
        guard let urlString = router?.dataStore?.webViewURL,
            let url = URL(string: urlString) else {
                print("Cannot initiliaze web view url")
                return
        }
        let urlRequest = URLRequest(url: url)
        webView.loadRequest(urlRequest)
    }
    
    // MARK: - Display Logic
    
}

// MARK: - UIWebViewDelegate

extension PaymentWebViewViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        if !isLoadingAlertVisible {
            isLoadingAlertVisible = true
            router?.showLoadingAlert()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        router?.dismissLoadingAlert(completion: { [weak self] in
            self?.isLoadingAlertVisible = false
        })
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        router?.dismissLoadingAlert(completion: { [weak self] in
            self?.isLoadingAlertVisible = false
        })
    }
    
}
