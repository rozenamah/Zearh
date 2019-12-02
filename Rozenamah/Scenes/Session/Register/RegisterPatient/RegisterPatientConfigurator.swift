import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension RegisterPatientViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = RegisterPatientInteractor()
        let presenter = RegisterPatientPresenter()
        let router = RegisterPatientRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
