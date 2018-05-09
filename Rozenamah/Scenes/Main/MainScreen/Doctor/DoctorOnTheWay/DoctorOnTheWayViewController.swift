import UIKit
import CoreLocation
import SwiftCake

protocol DoctorOnTheWayDisplayLogic: class {
    func presentError(_ error: Error)
    func doctorArrived(withBooking booking: Booking)
    func doctorCancelled()
}

class DoctorOnTheWayViewController: ModalInformationViewController, DoctorOnTheWayDisplayLogic {

    // MARK: Outlets
    
    // MARK: Properties
    var interactor: DoctorOnTheWayBusinessLogic?
    var router: DoctorOnTheWayRouter?

    // Delegate responsible for passing action to parent viewcontroller
    weak var flowDelegate: DoctortFlowDelegate?
    
    // Variable represents current booking for which doctor will serve services and where he will be driving
    var booking: Booking! {
        didSet {
            customizePatientInfo()
            interactor?.setupBooking(booking)
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
    
    func customizePatientInfo() {
        fillInformation(with: booking.patient, andVisitInfo: booking.visit)
    }

    // MARK: Event handling
    
    @IBAction func cancelAction(_ sender: Any) {
        interactor?.cancelVisit(for: booking)
    }
    
    @IBAction func arrivedAction(_ sender: Any) {
        interactor?.doctorArrived(for: booking)
    }
    
    @IBAction func patientInfoAction(_ sender: Any) {
        router?.navigateToPatient(inBooking: booking)
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        if booking.patient.phone != nil {
            router?.makeCall(to: "\(booking.patient.phone!)")
        }
    }
    
    // MARK: Presenter methods
    
    func presentError(_ error: Error) {
        router?.showError(error)
    }
    
    func doctorArrived(withBooking booking: Booking) {
        flowDelegate?.changeStateTo(flowPoint: .arrived(booking: booking))
    }
    
    func doctorCancelled() {
//        flowDelegate?.changeStateTo(flowPoint: .cancel)
    }
}
