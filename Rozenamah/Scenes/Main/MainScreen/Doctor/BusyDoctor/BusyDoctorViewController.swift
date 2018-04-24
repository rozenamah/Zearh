import UIKit
import CoreLocation

protocol BusyDoctorDisplayLogic: class {
}

class BusyDoctorViewController: UIViewController, BusyDoctorDisplayLogic {

    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    
    // MARK: Properties
    var interactor: BusyDoctorBusinessLogic?
    var router: BusyDoctorRouter?
    
    var visitDetails: VisitDetails!
    var locationManager = CLLocationManager()

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

    // MARK: Event handling
    
    

    // MARK: Presenter methods
}

extension BusyDoctorViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        interactor?.updateDoctorsLocation(location)
        
    }
}
