//
//  PhotoTakeRouter.swift
//  Rozenamah
//
//  Created by Dominik Majda on 14.03.2018.
//  Copyright © 2018 Dominik Majda. All rights reserved.
//

import UIKit


protocol PhotoTakeRouter {
    func navigateToSelectingImageSource(allowEditing: Bool)
}

extension PhotoTakeRouter where Self: Router {
    
    func navigateToSelectingImageSource(allowEditing: Bool = true){
        
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        let alert: UIAlertController = UIAlertController(title: nil,
                                                         message: nil,
                                                         preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "alerts.photo.takePhoto".localized, style: .default) { action in
            self.navigateToCamera(allowEditing: allowEditing)
        }
        
        let galleryAction = UIAlertAction(title: "alerts.chooseFromLibrary".localized, style: .default) { action in
            self.navigateToGallery(allowEditing: allowEditing)
        }
        let cancelAction = UIAlertAction(title: "generic.cancel", style: .cancel)
        
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
    fileprivate func navigateToCamera(allowEditing: Bool) {
        
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = allowEditing
            imagePicker.delegate = self as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    fileprivate func navigateToGallery(allowEditing: Bool) {
        
        guard let viewController = viewController as? UIViewController else {
            return
        }
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = allowEditing
            imagePicker.delegate = self as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
            viewController.present(imagePicker, animated: true, completion: nil)
        }
    }
}

