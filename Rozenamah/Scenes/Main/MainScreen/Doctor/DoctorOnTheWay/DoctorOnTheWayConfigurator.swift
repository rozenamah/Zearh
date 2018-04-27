import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension DoctorOnTheWayViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = DoctorOnTheWayInteractor()
        let presenter = DoctorOnTheWayPresenter()
        let router = DoctorOnTheWayRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
