import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension MainDoctorViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = MainDoctorInteractor()
        let presenter = MainDoctorPresenter()
        let router = MainDoctorRouter()
        viewController.interactorNew = interactor
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
