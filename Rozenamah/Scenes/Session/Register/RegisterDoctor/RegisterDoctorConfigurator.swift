import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension RegisterDoctorViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = RegisterDoctorInteractor()
        let presenter = RegisterDoctorPresenter()
        let router = RegisterDoctorRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
