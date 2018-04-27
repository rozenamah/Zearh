import UIKit
import CoreLocation
import SwiftCake

protocol DoctorOnTheWayDisplayLogic: class {
    func presentError(_ error: Error)
    func doctorArrived()
    func doctorCancelled()
}

class DoctorOnTheWayViewController: ModalInformationViewController, DoctorOnTheWayDisplayLogic {

    // MARK: Outlets
    
    // MARK: Properties
    var interactor: DoctorOnTheWayBusinessLogic?
    var router: DoctorOnTheWayRouter?
    
    var locationManager = CLLocationManager()
    // Delegate responsible for passing action to parent viewcontroller
    weak var flowDelegate: DoctortFlowDelegate?
    
    // Variable represents current booking for which doctor will serve services and where he will be driving
    var booking: Booking! {
        didSet {
            customizePatientInfo()
        }
    }

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: View customization

    fileprivate func setupView() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func customizePatientInfo() {
        fillInformation(with: booking.patient, andVisitInfo: booking.visit)
    }

    // MARK: Event handling
    
    @IBAction func cancelAction(_ sender: Any) {
        flowDelegate?.changeStateTo(flowPoint: .cancel)
    }
    
    @IBAction func arrivedAction(_ sender: Any) {
        interactor?.doctorArrived(for: "visitID")
    }
    
    @IBAction func patientInfoAction(_ sender: Any) {
        router?.navigateToPatientDetails()
    }
    
    // MARK: Presenter methods
    
    func presentError(_ error: Error) {
        router?.showError(error)
    }
    
    func doctorArrived() {
        flowDelegate?.changeStateTo(flowPoint: .arrived)
    }
    
    func doctorCancelled() {
        flowDelegate?.changeStateTo(flowPoint: .cancel)
    }
}

extension DoctorOnTheWayViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        interactor?.updateDoctorsLocation(location)
        let patientMock = CLLocation(latitude: 50.055246, longitude: 19.969307)
        // If doctor is less than 150 meters, send information to server
        if interactor?.checkIfDoctorCloseTo(patientMock) == true {
            interactor?.doctorArrived(for: "VisitID")
        }
        
    }
}
