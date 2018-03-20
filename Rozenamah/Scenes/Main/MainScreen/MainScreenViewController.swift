import UIKit
import GoogleMaps

protocol MainScreenDisplayLogic: class {
    func moveToPosition(_ cameraUpdate: GMSCameraUpdate)
    func animateToPosition(_ cameraUpdate: GMSCameraPosition)
}

class MainScreenViewController: UIViewController, MainScreenDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: Properties
    var interactor: MainScreenBusinessLogic?
    var router: MainScreenRouter?

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
        
        interactor?.registerForNotifications()
    }

    // MARK: View customization

    fileprivate func setupView() {
        mapView.isMyLocationEnabled = true
        
        // Adjust position of Google Map Logo - it is private API and might not be safe to use
        if let logoButton = mapView.subviews[1].subviews[0].subviews[3] as? UIButton {
            var frame = logoButton.frame
            let screenFrame = UIScreen.main.bounds
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            frame.origin.x = screenFrame.width - 16 - frame.width
            frame.origin.y = statusBarHeight + 26
            if #available(iOS 11, *) {
                 frame.origin.y -= view.safeAreaInsets.top
            }
            
            logoButton.frame = frame
        }
    }

    // MARK: Event handling

    @IBAction func slideMenuAction(_ sender: Any) {
        slideMenuController()?.toggleLeft()
    }
    
    @IBAction func callDoctorAction(_ sender: Any) {
    }
    
    @IBAction func locateMeAction(_ sender: Any) {
        interactor?.returnToUserLocation()
    }
    
    // MARK: Presenter methods
    
    /// Move map without animation
    func moveToPosition(_ cameraUpdate: GMSCameraUpdate) {
        mapView.moveCamera(cameraUpdate)
    }
    
    /// Move map with animation
    func animateToPosition(_ cameraUpdate: GMSCameraPosition) {
        mapView.animate(to: cameraUpdate)
    }
}
