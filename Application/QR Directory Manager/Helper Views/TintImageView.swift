//
//  TintImageView.swift
//  QR Directory Manager
//


import UIKit

@IBDesignable
class TintImageView: UIImageView {

    @IBInspectable var isTemplate: Bool {
        set {
            if let image = self.image {
                if newValue {
                    let newImage = image.withRenderingMode(.alwaysTemplate)
                    self.image = newImage
                } else {
                    let newImage = image.withRenderingMode(.alwaysOriginal)
                    self.image = newImage
                }
                
                setNeedsLayout()
            }
        } get {
            return false
        }
    }
}
