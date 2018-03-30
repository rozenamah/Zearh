import UIKit
import CoreLocation
import GoogleMaps
import UserNotifications

protocol MainPatientBusinessLogic: MainScreenBusinessLogic {
}

class MainPatientInteractor: MainScreenInteractor, MainPatientBusinessLogic {
	var presenter: MainPatientPresentationLogic?
	var worker = MainPatientWorker()

	// MARK: Business logic
}
