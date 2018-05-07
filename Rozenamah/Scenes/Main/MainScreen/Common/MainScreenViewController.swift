//
//  File.swift
//  Rozenamah
//
//  Created by Dominik Majda on 30.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol MainScreenDisplayLogic: class {
    func moveToPosition(_ cameraUpdate: GMSCameraUpdate)
    func animateToPosition(_ cameraUpdate: GMSCameraPosition)
}

class MainScreenViewController: UIViewController, MainScreenDisplayLogic {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    // Marker with doctors location, needs to be updated when location is changed
    private var locationMarker: GMSMarker?
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // If notificiation in AppDelegate exists it means app was started from push notification, resolve it here, in Main
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let lunchingNotification = appDelegate.launchOptions {
            appDelegate.application(UIApplication.shared, didReceiveRemoteNotification: lunchingNotification)
            appDelegate.launchOptions = nil
        }
    }
    
    // MARK: View customization
    
    func setupView() {
        mapView.isMyLocationEnabled = true
        
        // Adjust position of Google Map Logo - it is private API and might not be safe to use
        if let logoButton = mapView.subviews[1].subviews[0].subviews[3] as? UIButton {
            var frame = logoButton.frame
            let screenFrame = UIScreen.main.bounds
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            frame.origin.x = screenFrame.width - 16 - frame.width
            frame.origin.y = statusBarHeight + 26
            if iPhoneDetection.deviceType() == .iphoneX {
                frame.origin.y = -42
            }
            
            logoButton.frame = frame
        }
        
        // Hide container view
        containerView.isHidden = true
    }
    
    // MARK: Event handling
    
    @IBAction func slideMenuAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
    
    
    // MARK: Presenter methods
    
    /// Move map without animation
    func moveToPosition(_ cameraUpdate: GMSCameraUpdate) {
        mapView.moveCamera(cameraUpdate)
    }
    
    /// Move map with animation
    func animateToPosition(_ cameraUpdate: GMSCameraPosition) {
        mapView.animate(to: cameraUpdate)
        mapView.moveCamera(GMSCameraUpdate.scrollBy(x: 0, y: 10))
    }
    
    func presentUser(in location: CLLocation) {
        // If there is already marker on the map
        // and comes update to location, swap old one with new
        if locationMarker != nil {
            locationMarker?.map = nil
            locationMarker = nil
        }
        
        let icon = User.current?.type == .patient ? UIImage(named: "doctor_icon") : UIImage(named: "placeholder")
        locationMarker = GMSMarker(position: location.coordinate)
        locationMarker?.icon = icon
        locationMarker?.map = mapView
    }
}
