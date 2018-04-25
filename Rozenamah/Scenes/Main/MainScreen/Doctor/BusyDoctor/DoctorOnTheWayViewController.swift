import UIKit
import CoreLocation
import SwiftCake

protocol BusyDoctorDisplayLogic: class {
    func presentError(_ error: Error)
    func doctorArrived()
    func doctorCancelled()
}

class DoctorOnTheWayViewController: UIViewController, BusyDoctorDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var avatarImageView: SCImageView!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    
    // MARK: Properties
    var interactor: BusyDoctorBusinessLogic?
    var router: BusyDoctorRouter?
    
    var locationManager = CLLocationManager()
    // Delegate responsible for passing action to parent viewcontroller
    weak var flowDelegate: DoctortFlowDelegate?
    // When variable is set, fulfil user information
    var visitInfo: VisitDetails! {
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
        let user = visitInfo.user
        let visit = visitInfo.visit
        
        avatarImageView.setAvatar(for: user)
        nameLabel.text = user.fullname
        priceLabel.text = "\(visit.price) SAR"
        phoneNumber.setTitle(visit.phone ?? "No phone number", for: .normal)
        distanceButton.setTitle("\(visit.distanceInKM) km from you", for: .normal)
        
        // Without this phone number will rever title to previous one (it is a bug but source is uknown)
        phoneNumber.setTitle(visit.phone ?? "No phone number", for: .highlighted)
        distanceButton.setTitle("\(visit.distanceInKM) km from you", for: .highlighted)
        
        // If more then 10 kilometers, highlight distance to red
        distanceButton.tintColor = visit.distanceInKM > 10 ? .rmRed : .rmGray
        
        // If fee > 0, show fee label
        feeLabel.isHidden = visit.fee <= 0
        feeLabel.text = "+ \(visit.fee) SAR for cancellation"
        
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
