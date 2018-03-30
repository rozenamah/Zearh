import UIKit
import CoreLocation
import GoogleMaps

protocol MainPatientPresentationLogic: MainScreenPresentationLogic {
}

class MainPatientPresenter: MainScreenPresenter, MainPatientPresentationLogic {
	weak var viewController: MainPatientDisplayLogic?
    override var baseViewController: MainScreenDisplayLogic? {
        return viewController
    }

	// MARK: Presentation logic
	
}
