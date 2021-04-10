//
//  ImageThumbnailGenerator.swift
//  QR Directory Manager
//


import Foundation
import UIKit

class ImageThumbnailGenerator : ROThumbnailGenerator {
    
    var supportedExtensions:Array<String> = ["png", "jpg", "jpeg"]
    
    func getThumbnail(_ url:URL) -> UIImage {
        do {
            let data = try Data(contentsOf: url)
            if let img = UIImage(data: data) {
                return img
            } else {
                return #colorLiteral(red: 0.9921568627, green: 0.3607843137, blue: 0.3607843137, alpha: 1).image()
            }
        } catch {
            return #colorLiteral(red: 0.9921568627, green: 0.3607843137, blue: 0.3607843137, alpha: 1).image()
        }
    }
}
