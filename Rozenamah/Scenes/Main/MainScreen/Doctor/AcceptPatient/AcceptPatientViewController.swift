import UIKit
import SwiftCake
import CoreLocation
import MapKit

protocol AcceptPatientDisplayLogic: class {
    func patientAccepted(with booking: Booking)
    func patientRejected()
    func handle(error: Error)
}

class AcceptPatientViewController: ModalInformationViewController, AcceptPatientDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK: Properties
    var interactor: AcceptPatientBusinessLogic?
    var router: AcceptPatientRouter?
    
    // Delegate responsible for doctors action, whether accept or cancel patient
    weak var flowDelegate: DoctortFlowDelegate?
    
    // Information about patient for doctor when he is about to accept or decline visit
    var booking: Booking! {
        didSet {
            acceptButton.isUserInteractionEnabled = true
            rejectButton.isUserInteractionEnabled = true
            
            // Reset minutes
            minutes = 15
            // Fill screen with patient info
            customizePatientInfo()
        }
    }
    // Variable used for calculation acceptance time
    private  var minutes = 15

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
    
    private func startTimeLeftCounter() {
        var _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] (timer)   in
            if self?.minutes == 0 {
                timer.invalidate()
                return
            }
            // Self is weak because we want to avoid retain cycle
            self?.confirmationLabel.text = "Confirm in \((self?.minutes)! - 1) minutes to accept visit"
            self?.minutes -= 1
        }
    }
    
    func customizePatientInfo() {
        //newCode fix 0 km from doctor side
        booking.visit.latitude = booking.latitude
        booking.visit.longitude = booking.longitude
        fillInformation(with: booking.patient, andVisitInfo: booking.visit, withAddress: booking.address)
//        startTimeLeftCounter()
    }

    // MARK: Event handling

    @IBAction func acceptAction(_ sender: Any) {
        acceptButton.isUserInteractionEnabled = false
        rejectButton.isUserInteractionEnabled = false
        router?.showWaitAlert(sender: sender as! UIView)
        interactor?.acceptPatient(for: booking)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        LoginUserManager.sharedInstance.visitFound = false
        acceptButton.isUserInteractionEnabled = false
        rejectButton.isUserInteractionEnabled = false
        router?.showWaitAlert(sender: sender as! UIView)
        interactor?.rejectPatient(for: booking)
    }
    
    @IBAction func patientDetailsAction(_ sender: Any) {
        router?.navigateToPatient(inBooking: booking)
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        if booking.patient.phone != nil {
            router?.makeCall(to: "\(booking.patient.phone!)")
        }
    }
    
    @IBAction func mapAction(_ sender: Any) {
        // use default map application
        openMapsOptions()
    }
    
    
    func openMapsOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "generic.googleMap".localized, style: .default, handler: { (action) in
                // Open Google Map
                self.openGoogleMap()
            }))
        
        alert.addAction(UIAlertAction(title: "generic.defaultMap".localized, style: .default, handler: { (action) in
            // Open Default Apple Map
            self.openMap()
        }))
      
        alert.addAction(UIAlertAction(title: "generic.cancel".localized, style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openMap() {
        let lat:CLLocationDegrees = booking.latitude
        let long:CLLocationDegrees = booking.longitude
        let regionDistance:CLLocationDistance = 1000
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placeMark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = "Patient Loction"
        mapItem.openInMaps(launchOptions: options)
    }
    
    func openGoogleMap() {
        let googleMapInstall = UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)
        if googleMapInstall {
            UIApplication.shared.open(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(booking.latitude),\(booking.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string:
                "https://www.google.co.in/maps/dir/?saddr=&daddr=\(booking.latitude),\(booking.longitude)")! as URL, options: [:], completionHandler: nil)
        }
        
       
        
        // route Lahore to Gujranwala
//        UIApplication.shared.open(URL(string:"comgooglemaps://?center=31.5204,74.3587&zoom=14&views=traffic&q=32.1877,74.1945")!, options: [:], completionHandler: nil)
        
        
        //if show direction from current location leave saddr blank
//        UIApplication.sharedApplication().openURL(NSURL(string:
//            "comgooglemaps://?saddr=&daddr=\(place.latitude),\(place.longitude)&directionsmode=driving")!)

    }
    
    // MARK: Presenter methods
    
    func patientAccepted(with booking: Booking) {
        acceptButton.isUserInteractionEnabled = true
        rejectButton.isUserInteractionEnabled = true
        router?.hideWaitAlert()
        flowDelegate?.changeStateTo(flowPoint: .accepted(booking: booking))
    }
    
    func patientRejected() {
        acceptButton.isUserInteractionEnabled = true
        rejectButton.isUserInteractionEnabled = true
        router?.hideWaitAlert()
        flowDelegate?.changeStateTo(flowPoint: .cancel)
    }
    
    func handle(error: Error) {
        acceptButton.isUserInteractionEnabled = true
        rejectButton.isUserInteractionEnabled = true
        router?.hideWaitAlert()
        router?.showError(error, sender: self.view)
    }
}
