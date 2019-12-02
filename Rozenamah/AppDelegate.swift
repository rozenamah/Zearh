//
//  AppDelegate.swift
//  Rozenamah
//
//  Created by Dominik Majda on 02.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AlamofireNetworkActivityIndicator
import Fabric
import Crashlytics
import GoogleMaps
import SlideMenuControllerSwift
import KeychainAccess
import Localize
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    /// Stored launch options from notification, we use it if app was opened from push notification
    /// It is used Splash screen in order to redirect to correct module and state
    var launchOptions: [AnyHashable: Any]?
    
    /// When starting app sometimes there is pending booking, we save it here so it is gloablly accessible
    var launchBooking: Booking?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        storeLaunchOptionsIfAny(launchOptions: launchOptions)
        
        configureGlobalApperance()
        configureApp()
        configureAlamofire()
        configureLanguage()
        
        
        
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//
//        Messaging.messaging().delegate = self

      
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Refresh state of booking, it might be outdated
        //newCode for AI fetch pendig visit on application start and resume
        SplashWorker().fetchMyBooking { (refreshBooking, error) in
            if let refreshBooking = refreshBooking {
                if LoginUserManager.sharedInstance.lastBooking != nil {
                    if LoginUserManager.sharedInstance.lastBooking!.status != refreshBooking.status {
                        AppRouter.navigateTo(booking: refreshBooking)
                    }
                } else {
                    AppRouter.navigateTo(booking: refreshBooking)
                }
            } else {
                AppRouter.noVisit()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if LoginUserManager.sharedInstance.timer != nil {
            LoginUserManager.sharedInstance.timer.invalidate()
        }
    }

    // MARK: Notifications
    
    private func storeLaunchOptionsIfAny(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        // We could open the app from notification
        // We store it for later use after we are logged in with success
        if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
            self.launchOptions = userInfo
        }
        
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        // Save device token to currently logged user
        NotificationWorker().saveDeviceToken(inData: deviceToken) { (error) in
            // Do nothing
        }
    }
    
    
    
    
    
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        print("test")
//
//    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        #if DEBUG
        print(userInfo)
        #endif
        
        if application.applicationState != .inactive {
            AppRouter.navigateToScreen(from: userInfo)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        completionHandler([.badge, .sound, .alert])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let navController = self.window?.rootViewController as! UINavigationController
        let notificationSettingsVC = NotificationAlertViewController()
        navController.pushViewController(notificationSettingsVC, animated: true)
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
//        localize.resetLanguage()
        
        //commented By Najam change condition only
//        if(localize.currentLanguage == "ar")
      if Locale.current.languageCode == "ar" {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        Localize.shared.update(language: "ar")
      } else {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        Localize.shared.update(language: "en")
      }
    }
    
    fileprivate func configureApp() {
        
        // Keyboard manager
        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
        
        // Crashlytics
        Fabric.with([Crashlytics.self])
        
        // Google Maps
        GMSServices.provideAPIKey("AIzaSyD4YIMG6xuvbw8MQpthFVXLt4-yng6xzjk")
        
        // Slide menu
        let slideWidth = UIScreen.main.bounds.width * 0.82
        SlideMenuOptions.leftViewWidth = slideWidth // It should be 82%
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.panFromBezel = false
        
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


//Mark:- Payment Linking - Hassan Bhatti
extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Make sure that URL scheme is identical to the registered one
        if url.scheme?.localizedCaseInsensitiveCompare(Config.urlScheme) == .orderedSame {
            // Send notification to handle result in the view controller.
            NotificationCenter.default.post(name: Notification.Name(rawValue: Config.asyncPaymentCompletedNotificationKey), object: nil)
            return true
        }
        return false
    }
    
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }
}
