import UIKit
import CoreLocation
import SwiftCake

protocol DoctorLocationDisplayLogic: class {
    func visitCancelled()
    func updateDoctorLocation(_ location: CLLocation)
    func presentError(_ error: Error)
}

class DoctorLocationViewController: ModalInformationViewController, DoctorLocationDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var classificationLabel: UILabel!
    
    // MARK: Properties
    var interactor: DoctorLocationBusinessLogic?
    var router: DoctorLocationRouter?
    
    // Delegate for updating location of doctor, and cancellation of ongoing visit
    weak var flowDelegate: PatientFlowDelegate?
    
    var booking: Booking! {
        didSet {
            interactor?.stopObservingDoctorLocation()
            fillInformation(with: booking.visit.user, andVisitInfo: booking.visit)
            interactor?.observeDoctorLocation(for: booking)
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
    }
    
    override func fillInformation(with user: User, andVisitInfo visitInfo: VisitDetails) {
        super.fillInformation(with: booking.visit.user, andVisitInfo: booking.visit)
        classificationLabel.text = visitInfo.user.doctor?.classification.title
    }

    // MARK: Event handling

    @IBAction func cancelAction(_ sender: Any) {
        router?.showFeeAlert()
    }
    
    func cancelConfirmed() {
        interactor?.cancelVisit(for: booking)
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
