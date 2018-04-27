import UIKit

protocol TransactionHistoryBusinessLogic {
    func configureWith(timeRange: TimeRange) 
    func fetchTrasactionHistory()
}

class TransactionHistoryInteractor: TransactionHistoryBusinessLogic {
	var presenter: TransactionHistoryPresentationLogic?
	var worker = TransactionHistoryWorker()

    /// If this value is false, we know there is more transactions to download
    private var isMoreToDownload: Bool = true
    
    /// Represents current page of previous visits, we increment this with each request
    private var page = 0
    
    /// Current transaction time range
    private var timeRange: TimeRange!
    
	// MARK: Business logic
    
    /// Caled when we change time range - we reset page and info if there is anything more to download
    func configureWith(timeRange: TimeRange) {
        self.page = 0
        self.isMoreToDownload = false
        self.timeRange = timeRange
    }
    
    func fetchTrasactionHistory() {
        
        guard let user = User.current else {
            return
        }

        if !isMoreToDownload {
            return
        }
        
        worker.fetchTransactionHistory(for: user, with: timeRange) { (transactions, error) in
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
