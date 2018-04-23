import UIKit
import SwiftCake

protocol TransactionHistoryDisplayLogic: class {
    func presentTransactions(_ transactions: [Transaction])
    func handleError(error: Error)
}

class TransactionHistoryViewController: UIViewController, TransactionHistoryDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttonViewsCollection: [RMButtonWithSeparator]!
    @IBOutlet weak var dailyView: RMButtonWithSeparator!
    
    // MARK: Properties
    var interactor: TransactionHistoryBusinessLogic?
    var router: TransactionHistoryRouter?
    
    var transactions = [Transaction]()

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
        if let user = User.current {
            interactor?.fetchTrasactionHistory(for: user)
        }
    }

    // MARK: View customization

    fileprivate func setupView() {
        customizeDateButtons()
    }
    
    private func customizeDateButtons() {
        if User.current?.type == .patient {
            dailyView.isHidden = true
        }
    }

    // MARK: Event handling

    @IBAction func dailyAction(_ sender: SCButton) {
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func weeklyAction(_ sender: SCButton) {
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func monthlyAction(_ sender: SCButton) {
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func totalAction(_ sender: SCButton) {
        customizeSeparatorView(for: sender)
    }
    
    @IBAction func dissmisAction(_ sender: Any) {
        router?.dissmis()
    }
    
    // MARK: Presenter methods
    
    private func customizeSeparatorView(for button: SCButton) {
        buttonViewsCollection.forEach({ $0.separatorView.isHidden = true })
        let view = buttonViewsCollection.first(where: { $0.button == button })
        view?.separatorView.isHidden = false
    }
    
    func presentTransactions(_ transactions: [Transaction]) {
        
        self.transactions = transactions
        
    }
    
    func handleError(error: Error) {
        router?.showError(error)
    }

}

extension TransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registerCells() {
        tableView.registerNib(cell: SummaryTableViewCell.self)
        tableView.registerNib(cell: PastVisitTableViewCell.self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.navigateToTransactionDetail(for: transactions[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let transaction = transactions[indexPath.row]
        if indexPath.section == 0 {
            let cell = tableView.dequeueCell(withReusable: SummaryTableViewCell.self, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueCell(withReusable: PastVisitTableViewCell.self, for: indexPath)
            cell.transaction = transaction
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let user = User.current {
             interactor?.fetchTrasactionHistory(for: user)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Change later with array count
        return section == 0 ? 1 : transactions.count
    }
}
