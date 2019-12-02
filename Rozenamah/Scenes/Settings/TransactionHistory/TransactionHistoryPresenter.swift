import UIKit

protocol TransactionHistoryPresentationLogic {
    func handle(_ error: Error)
    func presentTransactions(_ transactions: TransactionHistory)
}

class TransactionHistoryPresenter: TransactionHistoryPresentationLogic {
	weak var viewController: TransactionHistoryDisplayLogic?

	// MARK: Presentation logic
	
    func handle(_ error: Error) {
        viewController?.handleError(error: error)
    }
    
    func presentTransactions(_ transactions: TransactionHistory) {
        viewController?.displayNextBookings(transactions.visits, withTotalMoney: transactions.cost, withTotalVisit: transactions.count)
    }
}
