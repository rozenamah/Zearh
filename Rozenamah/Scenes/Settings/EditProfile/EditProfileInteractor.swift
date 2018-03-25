import UIKit

protocol EditProfileBusinessLogic {
}

class EditProfileInteractor: EditProfileBusinessLogic {
	var presenter: EditProfilePresentationLogic?
	var worker = EditProfileWorker()

	// MARK: Business logic
	
}
