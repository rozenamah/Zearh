import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension TransactionDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = TransactionDetailInteractor()
        let presenter = TransactionDetailPresenter()
        let router = TransactionDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
