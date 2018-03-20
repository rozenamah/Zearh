import UIKit
import CoreLocation
import GoogleMaps

protocol MainScreenPresentationLogic {
    func moveCameraToPosition(location: CLLocation, withAnimation animation: Bool)
}

class MainScreenPresenter: MainScreenPresentationLogic {
	weak var viewController: MainScreenDisplayLogic?

	// MARK: Presentation logic
    
    func moveCameraToPosition(location: CLLocation, withAnimation animation: Bool) {
        let position = GMSCameraPosition(target: location.coordinate, zoom: 15.0, bearing: 0, viewingAngle: 0)
        
        if animation {
            viewController?.animateToPosition(position)
        } else {
            let update = GMSCameraUpdate.setCamera(position)
            viewController?.moveToPosition(update)
        }
    }
	
}
