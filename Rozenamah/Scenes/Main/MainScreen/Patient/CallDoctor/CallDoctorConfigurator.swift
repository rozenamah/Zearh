import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension CallDoctorViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = CallDoctorInteractor()
        let presenter = CallDoctorPresenter()
        let router = CallDoctorRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
