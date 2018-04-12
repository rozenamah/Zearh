import UIKit

protocol TransactionHistoryBusinessLogic {
}

class TransactionHistoryInteractor: TransactionHistoryBusinessLogic {
	var presenter: TransactionHistoryPresentationLogic?
	var worker = TransactionHistoryWorker()

	// MARK: Business logic
	
}
