import UIKit
import CoreLocation

protocol DoctorOnTheWayBusinessLogic {
    func updateDoctorsLocation(_ location: CLLocation)
    func checkIfDoctorCloseTo(_ patientLocation: CLLocation) -> Bool
    func doctorArrived(for visitId: String)
    func cancelVisit(for visitID: String)
}

class DoctorOnTheWayInteractor: DoctorOnTheWayBusinessLogic {
	var presenter: DoctorOnTheWayPresentationLogic?
	var worker = DoctorOnTheWayWorker()
    
    // Holds first location that we compare distance with later locations after updates
    private var baseLocation: CLLocation?

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
	
}
