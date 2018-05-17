import UIKit

protocol TransactionHistoryBusinessLogic {
    func configureWith(timeRange: TimeRange, andUserType userType: UserType)
    func fetchTrasactionHistory()
    
    var isMoreToDownload: Bool { get }
}

class TransactionHistoryInteractor: TransactionHistoryBusinessLogic {
	var presenter: TransactionHistoryPresentationLogic?
	var worker = TransactionHistoryWorker()

    /// If this value is false, we know there is more transactions to download
    var isMoreToDownload: Bool = true
    
    /// Represents current page of previous visits, we increment this with each request
    private var builder: TransactionHistoryBuilder!
    
	// MARK: Business logic
    
    /// Caled when we change time range - we reset page and info if there is anything more to download
    func configureWith(timeRange: TimeRange, andUserType userType: UserType) {
        isMoreToDownload = true
        builder = TransactionHistoryBuilder()
        builder.range = timeRange
        builder.userType = userType
    }
    
    func fetchTrasactionHistory() {
        if !isMoreToDownload {
            return
        }
        
        worker.fetchTransactionHistory(builder: builder) { (history, error) in
            
            if let error = error {
                self.presenter?.handle(error)
                return
            }
            
            if let history = history {
                self.builder.page += 1
                self.isMoreToDownload = (history.visits.count == self.builder.limit)
                self.presenter?.presentTransactions(history)
            }
        }
    }
	
}
