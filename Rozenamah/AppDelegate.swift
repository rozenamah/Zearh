//
//  AppDelegate.swift
//  Rozenamah
//
//  Created by Dominik Majda on 02.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import IQKeyboardManager
import AlamofireNetworkActivityIndicator
import Fabric
import Crashlytics
import GoogleMaps
import SlideMenuControllerSwift
import KeychainAccess
import Localize
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Stored launch options from notification, we use it if app was opened from push notification
    /// It is used Splash screen in order to redirect to correct module and state
    var launchOptions: [AnyHashable: Any]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        storeLaunchOptionsIfAny(launchOptions: launchOptions)
        
        configureGlobalApperance()
        configureApp()
        configureAlamofire()
        configureLanguage()
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    // MARK: Notifications
    
    private func storeLaunchOptionsIfAny(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        // We could open the app from notification
        // We store it for later use after we are logged in with success
        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            self.launchOptions = userInfo
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Save device token to currently logged user
        NotificationWorker().saveDeviceToken(inData: deviceToken) { (error) in
            // Do nothing
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        #if DEBUG
        print(userInfo)
        #endif
        
        AppRouter.navigateToProperScreen(from: userInfo)
    }
}

// MARK: Configuration

extension AppDelegate {
    
    fileprivate func configureLanguage() {
        let localize = Localize.shared
        // Set your localize provider.
        localize.update(provider: .json)
        // Set your file name
        localize.update(fileName: "lang")
        // If you want remove storaged languaje use
        localize.resetLanguage()
    }
    
    fileprivate func configureApp() {
        
        // Keyboard manager
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        // Crashlytics
        Fabric.with([Crashlytics.self])
        
        // Google Maps
        GMSServices.provideAPIKey("AIzaSyAQn-t2THtonY3SIyOyPTJTAskXO_f6KyY")
        
        // Slide menu
        let slideWidth = UIScreen.main.bounds.width * 0.82
        SlideMenuOptions.leftViewWidth = slideWidth // It should be 82%
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.panFromBezel = false
        
        // Firebase
        FirebaseApp.configure()
        
        // If app first launch - remove token in keychain memory if available
        if !Settings.shared.isFirstAppRun {
            Keychain.shared.token = nil
            Settings.shared.isFirstAppRun = true
        }
    }
    
    private func configureGlobalApperance() {
    
        UITextView.appearance().tintColor = UIColor.rmBlue
        UITextField.appearance().tintColor = UIColor.rmBlue
    }
    
    private func configureAlamofire() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
}

