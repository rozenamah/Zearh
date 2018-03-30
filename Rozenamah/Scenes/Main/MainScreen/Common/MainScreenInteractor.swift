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
    func returnToUserLocation()
    func registerForNotifications()
}

class MainScreenInteractor: NSObject, MainScreenBusinessLogic {
    
    private var locationManager = CLLocationManager()
    
    /// Whenever first location is found move camera to this position
    fileprivate var firstLocationDisplayed: Bool = false
    
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
//            presenter?.moveCameraToPosition(location: myLocation, withAnimation: true)
        }
    }
    
    private func startCurrentObservingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func stopCurrentObservingLocation() {
        locationManager.stopUpdatingLocation()
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
//            presenter?.moveCameraToPosition(location: firstLocation, withAnimation: false)
        }
    }
    
}
