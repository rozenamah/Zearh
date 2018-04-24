import UIKit
import SwiftCake

protocol DrawerDisplayLogic: class {
    func logoutSuccess()
}

class DrawerViewController: UIViewController, DrawerDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var avatarImageView: SCImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var createAccountView: UIView!
    @IBOutlet weak var switchAccountView: UIView!
    @IBOutlet weak var switchAccountButton: UIButton!
    @IBOutlet var drawerButtons: [UIButton]!
    @IBOutlet weak var avatarHeightConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    var interactor: DrawerBusinessLogic?
    var router: DrawerRouter?
    
    /// By this value we know if current app is in doctor or patient mode
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh drawer whenever we enter it
        fillUserData()
    }

    // MARK: View customization

    fileprivate func setupView() {
        
        if iPhoneDetection.deviceType() == .iphone5 ||
            iPhoneDetection.deviceType() == .iphone4 {
            stackView.spacing = 8
            drawerButtons.forEach {
                $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
            }
            nameLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            emailLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
            avatarHeightConstraint.constant = 70
            avatarImageView.cornerRadius = 35
        }
        
        // If doctor account active, display ability to switch to doctor account
        if currentMode == .doctor {
            switchAccountButton.setTitle("Patient account", for: .normal)
        }
    }
    
    private func fillUserData() {
        
        if let user = User.current {
            nameLabel.text = user.fullname
            emailLabel.text = user.email
            avatarImageView.setAvatar(for: user)
            
            // If user is patient - hide switch account view and show update to doctor view
            
            createAccountView.isHidden = user.type == .doctor
            switchAccountView.isHidden = user.type != .doctor
            
            // If account not verified - we gray out button a little
            if User.current?.doctor?.isVerified == true {
                switchAccountButton.alpha = 1
            } else {
                switchAccountButton.alpha = 0.3
            }
            
        }
    }

    // MARK: Event handling
    
    @IBAction func switchAccountType(_ sender: Any) {
        if currentMode == .doctor {
            // Doctor may be available, stop his avability
            interactor?.stopReceivingRequests()
        }
        
        // If account not verified - show error message
        if currentMode == .patient,
            User.current?.doctor?.isVerified == false {
            
            router?.showAlert(message: "Your doctor account is waiting for validation")
            return
        }
        router?.navigateToApp(inModule: currentMode == .doctor ? .patient : .doctor)
    }
    
    @IBAction func createDoctorAccount(_ sender: Any) {
        router?.navigateToCreateDoctorAccount()
    }
    
    @IBAction func editProfileAction(_ sender: Any) {
        router?.naviagateToEdit()
    }
    
    @IBAction func privacyPolicyAction(_ sender: Any) {
        router?.navigateToPrivacyPolicy()
    }
    
    @IBAction func termsAction(_ sender: Any) {
        router?.navigateToTermsAndConditions()
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        router?.showLogoutAlert()
    }
    @IBAction func transactionsAction(_ sender: Any) {
        router?.navigateToTransactions()
    }
    
    @IBAction func reportAction(_ sender: Any) {
        router?.navigateToReport()
    }
    /// Called from confirmation alert
    func loginCofirmed() {
        interactor?.logout()
    }
    
    // MARK: Presenter methods
    
    
    func logoutSuccess() {
        router?.navigateToSignUp()
    }
}
