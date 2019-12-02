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
    
    /// When calling method that doctor arrived we mark it true once so it is not called again
    fileprivate var isArrivedMethodCalled = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(for:)), name: MainDoctorRouter.kVisitRequestNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupBooking(_ booking: Booking) {
        self.booking = booking
        self.isArrivedMethodCalled = false
        self.startObservingLocation()
    }

	// MARK: Business logic
    
    @objc func handleNotification(for notification: NSNotification) {
        if let booking = notification.userInfo?["booking"] as? Booking,
            booking.status == .canceled {
            
            stopUpdatingLocation()
        }
    }
    
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    fileprivate func startObservingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func updateDoctorsLocation(_ location: CLLocation) {
        if baseLocation == nil {
            baseLocation = location
        }
        
        if userMovedRequiredDistance(location: location) {
            worker.updateLocationInDatabase(location, booking: booking)
        }
        
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
        if isArrivedMethodCalled {
            return
        }
        isArrivedMethodCalled = true
        
        worker.doctorArrived(for: booking) { (booking, error) in
            self.stopUpdatingLocation()
            
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            if let booking = booking {
                LoginUserManager.sharedInstance.bookingStatus = booking.status
                self.presenter?.doctorArrived(withBooking: booking)
            }
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
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // If doctor is less than 150 meters, send information to server
        if checkIfDoctorCloseTo(booking.patientLocation) {
            doctorArrived(for: booking)
        } else {
            updateDoctorsLocation(location)
        }
        
    }
}
