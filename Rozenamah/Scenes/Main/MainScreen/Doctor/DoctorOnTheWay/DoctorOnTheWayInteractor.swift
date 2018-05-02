import UIKit
import CoreLocation

protocol DoctorOnTheWayBusinessLogic {
    func updateDoctorsLocation(_ location: CLLocation)
    func checkIfDoctorCloseTo(_ patientLocation: CLLocation) -> Bool
    func doctorArrived(for visitId: String)
    func cancelVisit(for visitID: String)
}

class DoctorOnTheWayInteractor: NSObject, DoctorOnTheWayBusinessLogic {
	var presenter: DoctorOnTheWayPresentationLogic?
	var worker = DoctorOnTheWayWorker()
    
    // Holds first location that we compare distance with later locations after updates
    private var baseLocation: CLLocation?
    fileprivate var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

	// MARK: Business logic
    
    func cancelVisit(for visitID: String) {
        worker.cancelVisit(with: visitID) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            self.presenter?.doctorCancelled()
        }
    }
    
    func updateDoctorsLocation(_ location: CLLocation) {
        if baseLocation == nil {
            baseLocation = location
        }
        
        if userMovedRequiredDistance(location: location) {
            worker.updateLocationInDatabase(location)
        }
    }
    
    func doctorArrived(for visitId: String) {
        worker.doctorArrived(for: visitId) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            self.presenter?.doctorArrived()
        }
    }
    
    func checkIfDoctorCloseTo(_ patientLocation: CLLocation) -> Bool {
        let locationManager = CLLocationManager()
        guard let location = locationManager.location else {
            return false
        }
        let distance = Int(location.distance(from: patientLocation))
        
        return distance < 150
    }
    
    private func userMovedRequiredDistance(location: CLLocation) -> Bool {
        
        if Int(baseLocation?.distance(from: location) ?? 0) > 100 {
            // If distance is more than 100 meters, change base location to current
            baseLocation = location
            return true
        }
        return false
    }
    
    fileprivate func startObservingLocation() {
        locationManager.startUpdatingLocation()
    }
	
}

extension DoctorOnTheWayInteractor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startObservingLocation()
        case .denied, .restricted:
            // TODO: User can't user this app now
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        updateDoctorsLocation(location)
        let patientMock = CLLocation(latitude: 50.055246, longitude: 19.969307)
        // If doctor is less than 150 meters, send information to server
        if checkIfDoctorCloseTo(patientMock) == true {
            doctorArrived(for: "VisitID")
        }
        
    }
}
