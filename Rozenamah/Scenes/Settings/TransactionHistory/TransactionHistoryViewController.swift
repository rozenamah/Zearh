import UIKit
import SwiftCake

protocol TransactionHistoryDisplayLogic: class {
    func displayNextBookings(_ bookings: [Booking], withTotalMoney money: Int, withTotalVisit visit: Int)
    func handleError(error: Error)
}

class TransactionHistoryViewController: UIViewController, TransactionHistoryDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var tableView: SCStateTableView!
    @IBOutlet var buttonViewsCollection: [RMButtonWithSeparator]!
    @IBOutlet weak var dailyView: RMButtonWithSeparator!
    @IBOutlet weak var weeklyButton: SCButton!
    
    // MARK: Properties
    var interactor: TransactionHistoryBusinessLogic?
    var router: TransactionHistoryRouter?
    
    /// List of all previous visits in selected range of time
    fileprivate var previousBookings = [Booking]()
    
    fileprivate var totalMoney: Int = 0
    fileprivate var totalVisits: Int = 0
    
    /// By this value we know if current app is displaying patient or doctor mode
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
        registerCells()
        interactor?.configureWith(timeRange: .weekly, andUserType: currentMode)
        // Perform click on week button
        weeklyAction(weeklyButton)
    }

    // MARK: View customization

    fileprivate func setupView() {
        customizeDateButtons()
        tableView.state = .loading
        tableView.noItemsMessage = "settings.transactionHistory.noVisit".localized
    }
    
    private func customizeDateButtons() {
        /// Patient won't see "Daily" transactions
        if User.current?.type == .patient {
            dailyView.isHidden = true
        }
    }

    // MARK: Event handling

    @IBAction func dailyAction(_ sender: SCButton) {
        reloadContentWithin(timeRange: .daily)
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func weeklyAction(_ sender: SCButton) {
        reloadContentWithin(timeRange: .weekly)
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func monthlyAction(_ sender: SCButton) {
        reloadContentWithin(timeRange: .monthly)
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func totalAction(_ sender: SCButton) {
        reloadContentWithin(timeRange: .total)
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func dissmisAction(_ sender: Any) {
        router?.dissmis()
    }
    
    private func reloadContentWithin(timeRange: TimeRange) {
        previousBookings.removeAll()
        tableView.reloadData()
        tableView.contentOffset = .zero
        
        interactor?.configureWith(timeRange: timeRange, andUserType: currentMode)
        interactor?.fetchTrasactionHistory()
        
        // Show activity indicator, hide table view
        tableView.state = .loading
        
    }
    
    // MARK: Presenter methods
    
    
    private func customizeSeparatorView(for button: SCButton) {
        buttonViewsCollection.forEach({ $0.separatorView.isHidden = true })
        let view = buttonViewsCollection.first(where: { $0.button == button })
        view?.separatorView.isHidden = false
    }
    
    func displayNextBookings(_ bookings: [Booking], withTotalMoney money: Int, withTotalVisit visit: Int) {
        
        // Stop activity indicator, show table view
        
        if previousBookings.isEmpty, bookings.isEmpty {
            tableView.state = .noItems
        } else {
            tableView.state = .showItems
            previousBookings.append(contentsOf: bookings)
        }
        totalMoney = money
        totalVisits = visit
        tableView.reloadData()
    }
    
    func handleError(error: Error) {
        router?.showError(error, sender: self.view)
    }

}

extension TransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registerCells() {
        tableView.registerNib(cell: SummaryTableViewCell.self)
        tableView.registerNib(cell: PastVisitTableViewCell.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            router?.navigateToTransactionDetail(for: previousBookings[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueCell(withReusable: SummaryTableViewCell.self, for: indexPath)
            cell.visitsNumberLabel.text = "\(totalVisits)"
            cell.paymentAmountLabel.text = "\(totalMoney)"
            return cell
        } else {
            let booking = previousBookings[indexPath.row]
            let cell = tableView.dequeueCell(withReusable: PastVisitTableViewCell.self, for: indexPath)
            cell.currentMode = currentMode
            cell.booking = booking
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1,
            indexPath.row == previousBookings.count - 1,
            interactor?.isMoreToDownload == true {
            
            interactor?.fetchTrasactionHistory()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : previousBookings.count
    }
}
