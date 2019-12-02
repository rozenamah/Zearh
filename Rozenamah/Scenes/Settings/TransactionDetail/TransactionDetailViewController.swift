import UIKit
import GoogleMaps

protocol TransactionDetailDisplayLogic: class {
}

class TransactionDetailViewController: BasicModalInformationViewController, TransactionDetailDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var specialistLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rightAddressConstraint: NSLayoutConstraint!
    @IBOutlet weak var methodTypeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var leaveTimeLabel: UILabel!
    @IBOutlet weak var rightDateConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var calendarImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: Properties
    var interactor: TransactionDetailBusinessLogic?
    var router: TransactionDetailRouter?
    
    /// Visit which will be displayed in this screen
    var booking: Booking!

    /// By this value we know if we should display doctor or patient
    var currentMode: UserType!
    
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
        fillInformation(with: currentMode == .patient ? booking.visit.user : booking.patient, andVisitInfo: booking.visit, withAddress: nil)
        
        // Adjust view for arabic language
        if self.view.isRTL() {
            // Add needed space in between address label and map icon
            rightAddressConstraint.constant = 16 + mapImage.bounds.width
            // Add needed space in between date label and map calendar icon
            rightDateConstraint.constant = 16 + calendarImage.bounds.width
            feeLabel.textAlignment = .right
            specialistLabel.textAlignment = .right
            addressLabel.textAlignment = .right
        }
    }
    
    override func fillInformation(with user: User, andVisitInfo visitInfo: VisitDetails, withAddress address: String?) {
        super.fillInformation(with: user, andVisitInfo: booking.visit, withAddress: address)
        
        addressLabel.text = booking.address ?? "errors.unknownAddress".localized
        specialistLabel.isHidden = currentMode != .patient
        specialistLabel.text = booking.visit.user.doctor?.specialization?.title
        methodTypeLabel.text = booking.payment.title
        statusLabel.text = booking.status.title
        
        let position = booking.patientLocation.coordinate
        let locationMarker = GMSMarker(position: position)
        locationMarker.icon = UIImage(named: "patient_icon")
        locationMarker.map = mapView
        let cameraPosition = GMSCameraPosition(target: position, zoom: 15.0, bearing: 0, viewingAngle: 0)
        let update = GMSCameraUpdate.setCamera(cameraPosition)
        mapView.moveCamera(update)
        mapView.isUserInteractionEnabled = false
        
        dateLabel.text = booking.dates?.requestedAt?.printer.string(with: DateFormats.day.rawValue) ?? "errors.unknownDate".localized
        arrivalTimeLabel.text = booking.dates?.arrivedAt?.printer.string(with: DateFormats.time.rawValue) ?? "-"
        leaveTimeLabel.text = booking.dates?.endedAt?.printer.string(with: DateFormats.time.rawValue) ?? "-"
        
    }

    // MARK: Event handling
    
    // MARK: Presenter methods
}
