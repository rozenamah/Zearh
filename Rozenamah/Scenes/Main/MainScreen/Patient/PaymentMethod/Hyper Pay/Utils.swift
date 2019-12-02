import UIKit
import Localize

class Utils: NSObject {

    static func SDKVersion() -> String? {
        if let path = Bundle.main.path(forResource: "OPPWAMobile-Resources.bundle/version", ofType: "plist") {
            if let versionDict = NSDictionary(contentsOfFile: path) as? [String: String] {
                return versionDict["OPPVersion"]
            }
        }
        return ""
    }
    
    static func amountAsString() -> String {
        return String(format: "%.2f", Config.amount) + " " + Config.currency
    }
    
    static func showResult(presenter: UIViewController, success: Bool, message: String?) {
        let title = success ? "generic.success".localized : "generic.failure".localized
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "generic.ok".localized, style: UIAlertAction.Style.default, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = presenter.view
            popoverController.sourceRect = presenter.view.bounds
        }
        presenter.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- By Hassan Bhatti
    static func showResultWithHandler(presenter: UIViewController, success: Bool, message: String?, handler:@escaping ((UIAlertAction)->Void)) {
        let title = success ? "Success" : "Failure"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: success ? nil : handler)
        alertController.addAction(alertAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = presenter.view
            popoverController.sourceRect = presenter.view.bounds
        }
        presenter.present(alertController, animated: true, completion: nil)
    }
    
    static func configureCheckoutSettings() -> OPPCheckoutSettings {
        let checkoutSettings = OPPCheckoutSettings.init()
        checkoutSettings.paymentBrands = Config.checkoutPaymentBrands
//        checkoutSettings.shopperResultURL = Config.urlScheme + "://payment"
//        checkoutSettings.shopperResultURL = Config.urlScheme + "://result"
        checkoutSettings.shopperResultURL = Config.urlScheme + "://result"

        checkoutSettings.theme.navigationBarBackgroundColor = Config.mainColor
        checkoutSettings.theme.confirmationButtonColor = Config.mainColor
        checkoutSettings.theme.accentColor = Config.mainColor
        checkoutSettings.theme.cellHighlightedBackgroundColor = Config.mainColor
        checkoutSettings.theme.sectionBackgroundColor = Config.mainColor.withAlphaComponent(0.05)
        if Localize.shared.currentLanguage == "ar"  {
            checkoutSettings.language = "ar"
        } else {
            checkoutSettings.language = "en"
        }
        return checkoutSettings
    }
}
