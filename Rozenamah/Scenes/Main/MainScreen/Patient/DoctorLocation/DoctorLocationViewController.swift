import UIKit
import CoreLocation

protocol DoctorLocationDisplayLogic: class {
    func visitCancelled()
    func updateDoctorLocation(_ location: CLLocation)
    func presentError(_ error: Error)
}

class DoctorLocationViewController: UIViewController, DoctorLocationDisplayLogic {

    // MARK: Outlets

    // MARK: Properties
    var interactor: DoctorLocationBusinessLogic?
    var router: DoctorLocationRouter?
    // Delegate for updating location of doctor, and cancellation of ongoing visit
    weak var flowDelegate: PatientFlowDelegate?

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
