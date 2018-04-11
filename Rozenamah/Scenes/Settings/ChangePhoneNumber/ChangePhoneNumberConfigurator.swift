import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension ChangePhoneNumberViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router?.passDataToNextScene(segue: segue, sender: sender)
    }

   func setup() {
        let viewController = self
        let interactor = ChangePhoneNumberInteractor()
        let presenter = ChangePhoneNumberPresenter()
        let router = ChangePhoneNumberRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
}
