//
//  MainScreenPresenter.swift
//  Rozenamah
//
//  Created by Dominik Majda on 30.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

protocol MainScreenPresentationLogic {
    func moveCameraToPosition(location: CLLocation, withAnimation animation: Bool)
}

class MainScreenPresenter: MainScreenPresentationLogic {
    
    /// Subclass will override this to provide view controllre which can perform general
    /// main screen action like moving map camera
    var baseViewController: MainScreenDisplayLogic? {
        return nil
    }
    
    // MARK: Presentation logic
    
    func moveCameraToPosition(location: CLLocation, withAnimation animation: Bool) {
        let position = GMSCameraPosition(target: location.coordinate, zoom: 15.0, bearing: 0, viewingAngle: 0)
        
        if animation {
            baseViewController?.animateToPosition(position)
        } else {
            let update = GMSCameraUpdate.setCamera(position)
            baseViewController?.moveToPosition(update)
        }
    }
    
}
