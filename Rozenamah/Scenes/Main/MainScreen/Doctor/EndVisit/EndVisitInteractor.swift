import UIKit

protocol EndVisitBusinessLogic {
    func end(booking: Booking)
    func validate(cashReceived: Bool) -> Bool
}

class EndVisitInteractor: EndVisitBusinessLogic {
	var presenter: EndVisitPresentationLogic?
	var worker = EndVisitWorker()

    /// When calling method that doctor ended visit we mark it true once so it is not called again
    fileprivate var isEndMethodCalled = false
    
	// MARK: Business logic
	
    func end(booking: Booking) {
        if isEndMethodCalled {
            return
        }
        isEndMethodCalled = true
        
        worker.endVisit(for: booking) { (booking, error) in
            
            if let error = error {
                self.isEndMethodCalled = false
                self.presenter?.handle(error)
                return
            }
            if let booking = booking {
                self.presenter?.doctorEnded(booking: booking)
            }
        }
    }
    
    func validate(cashReceived: Bool) -> Bool {
        if !cashReceived {
            presenter?.presentError(.cashNotTaken)
            return false
        }
        
        return true
    }
}
