import UIKit

protocol TransactionHistoryBusinessLogic {
    func fetchTrasactionHistory(for user: User)
}

class TransactionHistoryInteractor: TransactionHistoryBusinessLogic {
	var presenter: TransactionHistoryPresentationLogic?
	var worker = TransactionHistoryWorker()

    private var isMoreToDownload: Bool = true
    
	// MARK: Business logic
    
    func fetchTrasactionHistory(for user: User) {

        if !isMoreToDownload {
            return
        }
        
        worker.fetchTransactionHistory(for: user) { (transactions, error) in
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            
            if let transactions = transactions {
                self.isMoreToDownload = (transactions.count == TransactionHistoryWorker.kHistoryLimit)
                self.presenter?.presentTransactions(transactions)
            }
        }
    }
	
}
