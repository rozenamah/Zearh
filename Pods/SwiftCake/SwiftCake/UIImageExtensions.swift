//
//  UIImageExtensions.swift
//  SwiftCake
//
//  Created by Dominik Majda on 26.03.2017.
//  Copyright © 2017 Dominik Majda. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    /// Returns this image with bigger dimension scaled down to given value
    /// It doesn't scale image if it is already smaller
    ///
    /// - parameter maxDimension: maximum width or height of photo
    ///
    /// - returns: the same image, but resized to given size
    public func resizeImage(toMaxDimension maxDimension: CGFloat = 900) -> UIImage? {
        
        // If image is smaller then required size, do nothing
        if maxDimension > size.width, maxDimension > size.height {
            return self
        }
        
        // Grab bigger dimension and calculate scale and values
        var scale: CGFloat
        var newWidth: CGFloat
        var newHeight: CGFloat
        if size.width > size.height {
            scale = maxDimension / size.width
            newWidth = maxDimension
            newHeight = size.height * scale
        } else {
            scale = maxDimension / size.height
            newWidth = size.width * scale
            newHeight = maxDimension
        }
        
        // Create image with new dimensions
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    
    /// Returns this image with bigger dimension scaled down to given value
    /// It doesn't scale image if it is already smaller
    ///
    /// - parameter maxDimension: maximum width or height of photo
    ///
    /// - returns: the same image, but resized to given size and changed to JPEG data
    public func resizeToJPEGRepresentation(toMaxDimension maxDimension: CGFloat = 900) -> Data? {
        
        // Resize and decode image to be data
        guard let resizedImage = self.resizeImage(toMaxDimension: maxDimension),
            let dataImage = UIImageJPEGRepresentation(resizedImage, 0.9) else {
                return nil
        }
        return dataImage
    }
}
