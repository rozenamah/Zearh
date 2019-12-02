import UIKit
import CoreLocation
import SwiftCake
import MapKit

protocol DoctorOnTheWayDisplayLogic: class {
    func presentError(_ error: Error)
    func doctorArrived(withBooking booking: Booking)
    func doctorCancelled()
}

class DoctorOnTheWayViewController: ModalInformationViewController, DoctorOnTheWayDisplayLogic {
    // MARK: Outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    // MARK: Properties
    var interactor: DoctorOnTheWayBusinessLogic?
    var router: DoctorOnTheWayRouter?

    // Delegate responsible for passing action to parent viewcontroller
    weak var flowDelegate: DoctortFlowDelegate?
    
    // Variable represents current booking for which doctor will serve services and where he will be driving
    var booking: Booking! {
        didSet {
            acceptButton.isUserInteractionEnabled = true
            cancelButton.isUserInteractionEnabled = true
            
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
        //newCode fix 0 km from doctor side
        booking.visit.latitude = booking.latitude
        booking.visit.longitude = booking.longitude
        fillInformation(with: booking.patient, andVisitInfo: booking.visit, withAddress: booking.address)
    }

    // MARK: Event handling
    
    @IBAction func cancelAction(_ sender: Any) {
        router?.showCancelAlert(sender: sender as! UIView)
    }
    
    @IBAction func arrivedAction(_ sender: Any) {
        acceptButton.isUserInteractionEnabled = false
        cancelButton.isUserInteractionEnabled = false
        router?.showWaitAlert(sender: sender as! UIView)
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
    
    
    @IBAction func mapAction(_ sender: Any) {
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
    
    func cancelConfirmed() {
        acceptButton.isUserInteractionEnabled = false
        cancelButton.isUserInteractionEnabled = false
        router?.showWaitAlert(sender: self.view)
        interactor?.cancelVisit(for: booking)
    }
    
    // MARK: Presenter methods
    
    func presentError(_ error: Error) {
        acceptButton.isUserInteractionEnabled = true
        cancelButton.isUserInteractionEnabled = true
        router?.hideWaitAlert()
        router?.showError(error, sender: self.view)
    }
    
    func doctorArrived(withBooking booking: Booking) {
        acceptButton.isUserInteractionEnabled = true
        cancelButton.isUserInteractionEnabled = true
        router?.hideWaitAlert()
        flowDelegate?.changeStateTo(flowPoint: .arrived(booking: booking))
    }
    
    func doctorCancelled() {
        acceptButton.isUserInteractionEnabled = true
        cancelButton.isUserInteractionEnabled = true
        router?.hideWaitAlert()
//        flowDelegate?.changeStateTo(flowPoint: .cancel)
    }
}
