import UIKit
import CoreLocation
import GoogleMaps
import UserNotifications

protocol MainPatientBusinessLogic: MainScreenBusinessLogic {
}

class MainPatientInteractor: MainScreenInteractor, MainPatientBusinessLogic {
	var presenter: MainPatientPresentationLogic?
	var worker = MainPatientWorker()
    override var basePresenter: MainScreenPresenter? {
        return presenter as? MainScreenPresenter
    }

	// MARK: Business logic
}
