import UIKit
import CoreLocation
import SwiftCake

protocol DoctorLocationDisplayLogic: class {
    func visitCancelled()
    func updateDoctorLocation(_ location: CLLocation)
    func presentError(_ error: Error)
}

class DoctorLocationViewController: UIViewController, DoctorLocationDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: SCImageView!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    
    // MARK: Properties
    var interactor: DoctorLocationBusinessLogic?
    var router: DoctorLocationRouter?
    
    // Delegate for updating location of doctor, and cancellation of ongoing visit
    weak var flowDelegate: PatientFlowDelegate?
    
    var visitInfo: VisitDetails! {
        didSet {
            customizeDoctorInfo()
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
        interactor?.observeDoctorLocation(for: "visitId")
    }
    
    func customizeDoctorInfo() {
        let user = visitInfo.user
        let visit = visitInfo.visit
        avatarImage.setAvatar(for: user)
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
        router?.showFeeAlert()
    }
    
    func cancelConfirmed() {
        interactor?.cancelVisit(for: "123123")
    }
    
    // MARK: Presenter methods
    
    func visitCancelled() {
        flowDelegate?.changeStateTo(flowPoint: .callDoctor)
    }
    
    func updateDoctorLocation(_ location: CLLocation) {
        flowDelegate?.changeStateTo(flowPoint: .doctorLocation(location: location))
    }
    
    func presentError(_ error: Error) {
        router?.showError(error)
    }
}
