import UIKit

protocol TransactionDetailBusinessLogic {
}

class TransactionDetailInteractor: TransactionDetailBusinessLogic {
	var presenter: TransactionDetailPresentationLogic?
	var worker = TransactionDetailWorker()

	// MARK: Business logic
	
}
