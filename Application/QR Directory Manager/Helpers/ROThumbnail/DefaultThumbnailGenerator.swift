//
//  DefaultThumbnailGenerator.swift
//  QR Directory Manager
//

import Foundation
import UIKit

class DefaultThumbnailGenerator : ROThumbnailGenerator {
    
    var supportedExtensions:Array<String> = []
    
    func getThumbnail(_ url: URL) -> UIImage {
        return #colorLiteral(red: 0.9921568627, green: 0.3607843137, blue: 0.3607843137, alpha: 1).image()
    }
}
