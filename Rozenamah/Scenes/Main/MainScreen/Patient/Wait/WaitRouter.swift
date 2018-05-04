import UIKit

class WaitRouter: Router, AlertRouter {
    typealias RoutingViewController = WaitViewController
    weak var viewController: WaitViewController?
    
     private static let kVisitAcceptedNotification
        = Notification.Name("kVisitAcceptedNotification")
    private static let kVisitRejectedNotification
        = Notification.Name("kVisitRejectedNotification")
    
     init() {
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToDoctorOnTheWay(with:)), name: WaitRouter.kVisitAcceptedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToCallDoctor(with:)), name: WaitRouter.kVisitRejectedNotification, object: nil)
        
    }

    // MARK: Routing
    
    func passDataToNextScene(segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: Navigation
    
    static func resolve(booking: Booking, with status: BookingStatus) {
        if status == .accepted {
            NotificationCenter.default.post(name: WaitRouter.kVisitAcceptedNotification, object: nil, userInfo: ["accepted": booking])
        } else if status == .rejected {
          NotificationCenter.default.post(name: WaitRouter.kVisitRejectedNotification, object: nil, userInfo: ["rejected": booking])
        }
        
    }
    
    @objc func navigateToDoctorOnTheWay(with notification: Notification) {
        if let booking = notification.userInfo?["accepted"] as? Booking {
            viewController?.state = WaitType.doctorOnTheWay(booking: booking)
        }
       
    }
    
    @objc func navigateToCallDoctor(with notification: Notification) {
        if let booking = notification.userInfo?["rejected"] as? Booking {
            viewController?.flowDelegate?.changeStateTo(flowPoint: .cancel)
        }
    }
    
    func showNoDoctorFound() {
        let alert = UIAlertController(title: "Sorry", message: "We can't find any doctor matching your criteria", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            self.viewController?.flowDelegate?.changeStateTo(flowPoint: .callDoctor)
        }))
        viewController?.present(alert, animated: true, completion: nil)
    }

    // MARK: Passing data

}
