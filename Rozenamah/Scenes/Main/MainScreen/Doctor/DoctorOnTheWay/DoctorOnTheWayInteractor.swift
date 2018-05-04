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
    
    func cancelVisit(for booking: Booking) {
        worker.cancelVisit(with: booking) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            stopUpdatingLocation()
            self.presenter?.doctorCancelled()
        }
    }
    
    func updateDoctorsLocation(_ location: CLLocation) {
        if baseLocation == nil {
            baseLocation = location
        }
  
        if userMovedRequiredDistance(location: location) {
            worker.updateLocationInDatabase(location, booking: booking)
        }
    }
    
    func doctorArrived(for booking: Booking) {
        worker.doctorArrived(for: booking) { (error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            stopUpdatingLocation()
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
    
   private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
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
        let patientLocation = CLLocation(latitude: booking.latitude, longitude: booking.longitude)
        // If doctor is less than 150 meters, send information to server
        if checkIfDoctorCloseTo(patientLocation) == true {
            doctorArrived(for: booking)
        }
        
    }
}
