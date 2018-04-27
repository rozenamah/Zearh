import UIKit
import CoreLocation
import GoogleMaps

protocol MainPatientPresentationLogic: MainScreenPresentationLogic {
    func presentDoctorLocations(_ locations: [CLLocationCoordinate2D])
}

class MainPatientPresenter: MainScreenPresenter, MainPatientPresentationLogic {
	weak var viewController: MainPatientDisplayLogic?
    override var baseViewController: MainScreenDisplayLogic? {
        return viewController
    }

	// MARK: Presentation logic
	
    func presentDoctorLocations(_ locations: [CLLocationCoordinate2D]) {
        
        let markers = locations.map { (location) -> GMSMarker in
            let marker = GMSMarker(position: location)
            marker.icon = UIImage(named: "surgeon")
            return marker
        }
        
        viewController?.displayMarkersWithNearbyDoctors(markers)
        
    }
}
