import UIKit

protocol TransactionHistoryBusinessLogic {
    func fetchTrasactionHistory(for user: User)
}

class TransactionHistoryInteractor: TransactionHistoryBusinessLogic {
	var presenter: TransactionHistoryPresentationLogic?
	var worker = TransactionHistoryWorker()

    /// If this value is false, we know there is more transactions to download
    private var isMoreToDownload: Bool = true
    
    /// Represents current page of previous visits, we increment this with each request
    private var page = 0
    
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
                self.page += 1
                self.isMoreToDownload = (transactions.count == TransactionHistoryWorker.kHistoryLimit)
                self.presenter?.presentTransactions(transactions)
            }
        }
    }
	
}
