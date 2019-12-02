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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var classificationLabel: UILabel!
    
    // MARK: Properties
    var interactor: DoctorLocationBusinessLogic?
    var router: DoctorLocationRouter?
    
    // Delegate for updating location of doctor, and cancellation of ongoing visit
    weak var flowDelegate: PatientFlowDelegate?
    
    var booking: Booking! {
        didSet {
            cancelButton.isUserInteractionEnabled = true
            
            interactor?.stopObservingDoctorLocation()
            fillInformation(with: booking.visit.user, andVisitInfo: booking.visit, withAddress: nil)
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
        if view.isRTL() {
            classificationLabel.textAlignment = .right
        }
    }
    
    override func fillInformation(with user: User, andVisitInfo visitInfo: VisitDetails, withAddress address: String?) {
        super.fillInformation(with: booking.visit.user, andVisitInfo: booking.visit, withAddress: address)
        phoneNumber.setTitle(user.phone ?? "No phone number", for: .normal)
        classificationLabel.text = visitInfo.user.doctor?.classification.title
    }

    // MARK: Event handling

    @IBAction func cancelAction(_ sender: Any) {
        router?.showFeeAlert(sender: sender as! UIView)
    }
    
    func cancelConfirmed() {
        cancelButton.isUserInteractionEnabled = false
        interactor?.cancelVisit(for: booking)
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        if booking.visit.user.phone != nil {
            router?.makeCall(to: "\(booking.visit.user.phone!)")
        }
    }
    
    // MARK: Presenter methods
    
    func visitCancelled() {
        // We don't have to call it because we will get notificaion
        //flowDelegate?.changeStateTo(flowPoint: .callDoctor)
        cancelButton.isUserInteractionEnabled = true
    }
    
    func updateDoctorLocation(_ location: CLLocation) {
        flowDelegate?.changeStateTo(flowPoint: .doctorLocation(location: location))
    }
    
    func presentError(_ error: Error) {
        cancelButton.isUserInteractionEnabled = true
        router?.showError(error, sender: self.view)
    }
}
