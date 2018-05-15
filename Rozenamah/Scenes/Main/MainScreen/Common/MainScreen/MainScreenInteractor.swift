//
//  MainScreenInteractor.swift
//  Rozenamah
//
//  Created by Dominik Majda on 30.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import UserNotifications

protocol MainScreenBusinessLogic {
    /// Whenever first location is found move camera to this position
    var firstLocationDisplayed: Bool { get set }
    
    func returnToUserLocation()
    func registerForNotifications()
}

class MainScreenInteractor: NSObject, MainScreenBusinessLogic {
    
    /// Subclass will override this to provide presenter on whichwe  can perform general actions
    var basePresenter: MainScreenPresenter? {
        return nil
    }
    
    var locationManager = CLLocationManager()
    
    /// Whenever first location is found move camera to this position
    var firstLocationDisplayed: Bool = false
    
    // MARK: Business logic
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func registerForNotifications() {
        // Ask user about push notifications permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else {
                return
            }
            self.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else {
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func returnToUserLocation() {
        if let myLocation = locationManager.location {
            basePresenter?.moveCameraToPosition(location: myLocation, withAnimation: true)
        }
    }
    
    private func startCurrentObservingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopCurrentObservingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func firstLocationFetched() {
        
    }
}

extension MainScreenInteractor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startCurrentObservingLocation()
        case .denied, .restricted:
            // TODO: User can't user this app now
            break
        default:
            break
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let firstLocation = locations.first, !firstLocationDisplayed {
            firstLocationDisplayed = true
            basePresenter?.moveCameraToPosition(location: firstLocation, withAnimation: false)
            
            // Call hook, subclass can override this in order to be notified when first location was loaded
            firstLocationFetched()
        }
    }
    
}
