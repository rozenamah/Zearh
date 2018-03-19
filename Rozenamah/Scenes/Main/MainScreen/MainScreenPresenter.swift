import UIKit
import CoreLocation
import GoogleMaps

protocol MainScreenPresentationLogic {
    func moveCameraToPosition(location: CLLocation)
}

class MainScreenPresenter: MainScreenPresentationLogic {
	weak var viewController: MainScreenDisplayLogic?

	// MARK: Presentation logic
    
    func moveCameraToPosition(location: CLLocation) {
        let cameraUpdate = GMSCameraPosition(target: location.coordinate, zoom: 15.0, bearing: 0, viewingAngle: 0)
        viewController?.moveToPosition(cameraUpdate)
    }
	
}
