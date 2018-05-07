import UIKit
import CoreLocation

protocol DoctorOnTheWayBusinessLogic {
    func updateDoctorsLocation(_ location: CLLocation)
    func checkIfDoctorCloseTo(_ patientLocation: CLLocation) -> Bool
    func doctorArrived(for booking: Booking)
    func cancelVisit(for booking: Booking)
    func setupBooking(_ booking: Booking)
    func stopUpdatingLocation()
}

class DoctorOnTheWayInteractor: NSObject, DoctorOnTheWayBusinessLogic {
	var presenter: DoctorOnTheWayPresentationLogic?
	var worker = DoctorOnTheWayWorker()
    
    // Holds first location that we compare distance with later locations after updates
    private var baseLocation: CLLocation?
    fileprivate var locationManager = CLLocationManager()
    fileprivate var booking: Booking!
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func setupBooking(_ booking: Booking) {
        self.booking = booking
    }

	// MARK: Business logic
    
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    fileprivate func startObservingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func updateDoctorsLocation(_ location: CLLocation) {
        worker.updateLocationInDatabase(location, booking: booking)
    }
    
    func cancelVisit(for booking: Booking) {
        worker.cancelVisit(with: booking) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            self.stopUpdatingLocation()
            self.presenter?.doctorCancelled()
        }
    }
    
    func doctorArrived(for booking: Booking) {
        worker.doctorArrived(for: booking) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            self.stopUpdatingLocation()
            self.presenter?.doctorArrived()
        }
    }
    
    // MARK: Utils
    
    func checkIfDoctorCloseTo(_ patientLocation: CLLocation) -> Bool {
        let locationManager = CLLocationManager()
        guard let location = locationManager.location else {
            return false
        }
        let distance = Int(location.distance(from: patientLocation))
        
        return distance < 150
    }
    
    
    private func userMovedRequiredDistance(location: CLLocation) -> Bool {
        
        if baseLocation == nil {
            baseLocation = location
        }
        
        guard let baseLocation = baseLocation,
            Int(baseLocation.distance(from: location)) > 100 else {
            return false
        }
        // If distance is more than 100 meters, change base location to current
        self.baseLocation = location
        return true
    }
}

extension DoctorOnTheWayInteractor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startObservingLocation()
        case .denied, .restricted:
            // TODO: User can't use this app now
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        if userMovedRequiredDistance(location: location) {
            updateDoctorsLocation(location)
        }
        
        // If doctor is less than 150 meters, send information to server
        if checkIfDoctorCloseTo(booking.patientLocation) == true {
            doctorArrived(for: booking)
        }
        
    }
}
