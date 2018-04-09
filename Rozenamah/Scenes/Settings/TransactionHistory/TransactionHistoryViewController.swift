import UIKit
import SwiftCake

protocol TransactionHistoryDisplayLogic: class {
}

class TransactionHistoryViewController: UIViewController, TransactionHistoryDisplayLogic {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttonViewsCollection: [RMButtonWithSeparator]!
    
    // MARK: Properties
    var interactor: TransactionHistoryBusinessLogic?
    var router: TransactionHistoryRouter?

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
    }

    // MARK: View customization

    fileprivate func setupView() {
        
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
}

extension TransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    fileprivate func registerCells() {
        tableView.registerNib(cell: SummaryTableViewCell.self)
        tableView.registerNib(cell: ProfileTableViewCell.self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueCell(withReusable: SummaryTableViewCell.self, for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueCell(withReusable: ProfileTableViewCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
