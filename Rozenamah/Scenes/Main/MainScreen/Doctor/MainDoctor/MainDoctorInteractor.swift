import UIKit
import CoreLocation
import Alamofire

protocol MainDoctorBusinessLogic: MainScreenBusinessLogic {
    func stopReceivingRequests()
    func startReceivingRequests()
    func acceptPatient(for visitId: String)
    func rejectPatient(for visitId: String)
}

class MainDoctorInteractor: MainScreenInteractor, MainDoctorBusinessLogic {
	var presenter: MainDoctorPresentationLogic?
	var worker = MainDoctorWorker()
    override var basePresenter: MainScreenPresenter? {
        return presenter as? MainScreenPresenter
    }
    
    /// When doctor moves, he need to change his location by this number of meters in order for us to send
    /// his new location
    private let kDistanceBetweenNextRequest: Double = 200
    
    
    /// Timeinterval between next request updating user location
    private let kTimeIntervalBetweenNextRequest: Double = 3 * 60
    
    /// Last sent location of doctor
    private var lastSentLocation: CLLocation?
    
    /// Timestamp when we last sent user location, we use it in order to send user location every 3 minutes
    private var lastSavedDate: Double?
    
    /// Currently running query to save position
    private var lastRequest: DataRequest?

	// MARK: Business logic
    
    func rejectPatient(for visitId: String) {
        worker.rejectPatient(for: visitId) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            self.presenter?.patienRejected()
        }
    }
    
    func acceptPatient(for visitId: String) {
        worker.acceptPatient(for: visitId) { (error) in
            if let error = error {
                self.presenter?.handleError(error)
                return
            }
            self.presenter?.patientAccepted()
        }
    }
	
    func startReceivingRequests() {
        
        guard let location = locationManager.location else {
            // TODO: No location, show error
            return
        }
        
        worker.updateAvabilityTo(true) { [weak self] (error) in
            if let error = error {
                self?.presenter?.handleError(error)
                return
            }
            self?.presenter?.avabilityUpdatedTo(true)
            
            // Send doctor location immidiatly
            self?.updateUserLocation(location)
        }
    }
    
    func stopReceivingRequests() {
        worker.updateAvabilityTo(false) { [weak self] (error) in
            if let error = error {
                self?.presenter?.handleError(error)
                return
            }
            self?.presenter?.avabilityUpdatedTo(false)
        }
    }
    
    /// Update user location, if valudateTime = true, we check if time passed more then 5 mintues between last call, otherwise we skip
    private func updateUserLocation(_ location: CLLocation, validateTime: Bool = false) {
        
        if lastRequest != nil {
            return
        }
        
        if validateTime,
            let lastTimestamp = lastSavedDate,
            Date().timeIntervalSince1970 - lastTimestamp  > kTimeIntervalBetweenNextRequest {
            return
        }
        
        lastRequest = worker.updateLocation(to: location, completion: { (error) in
            // Save last call time
            self.lastSavedDate = Date().timeIntervalSince1970
            self.lastSentLocation = location
            self.lastRequest = nil
        })
    }
    
    // MARK: Location manager
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        
        guard let newLocation = locations.first else {
            return
        }
        
        // Check if doctor changed distance within 100 meters
        if lastSentLocation == nil ||
            lastSentLocation!.distance(from: newLocation) >= kDistanceBetweenNextRequest {
            
            updateUserLocation(newLocation, validateTime: false)
        }
    }
}
