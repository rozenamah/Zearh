import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension AcceptPatientViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = AcceptPatientInteractor()
        let presenter = AcceptPatientPresenter()
        let router = AcceptPatientRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
