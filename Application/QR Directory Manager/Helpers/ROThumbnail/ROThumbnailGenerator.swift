//
//  ROThumbnailGenerator.swift
//  QR Directory Manager
//

import Foundation
import UIKit

/**
 ROThumbnailGenerator class is the protocol for implementing your own ThumbnailGenerators
 You can easily add yourself to the ROThumbnail class
 */
public protocol ROThumbnailGenerator {
    
    // Define the exensions which are supported by this thumbnail generator implementation
    var supportedExtensions:Array<String> { get }
    
    /**
     Create a UIImage thumbnail from the given URL
     
     - parameter url: The url to the document the thumbnail should be generated.
     
     - returns: thumbnail The created thumbnail image.
     */
    func getThumbnail(_ url:URL) -> UIImage;
}
