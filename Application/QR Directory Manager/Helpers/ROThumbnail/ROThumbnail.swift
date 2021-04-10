//
//  ROThumbnail.swift
//  QR Directory Manager
//

import Foundation
import UIKit

open class ROThumbnail {
    
    public static let sharedInstance:ROThumbnail = ROThumbnail()
    open var imageQuality:CGFloat = 1.0 // Default is 100% JPEG image quality
    fileprivate var supportedFiletypes:Dictionary<String, ROThumbnailGenerator> = [:]
    
    public enum MediaType: String {
        case Image
        case Video
        case Document
        case Unknown
    }
    
    init() {
        self.initializeSupportedGenerators()
    }
    
    fileprivate func initializeSupportedGenerators() {
        // Add all per default added Thumbnail generators
        // If you want to add your own thumbnail generator use the method ROThumbnail.sharedInstance.addThumbnailGenerator(yourGenerator)
        addThumbnailGenerator(ImageThumbnailGenerator())
        addThumbnailGenerator(PDFThumbnailGenerator())
        addThumbnailGenerator(TextThumbnailGenerator())
        addThumbnailGenerator(VideoThumbnailGenerator())
    }
    
    /**
     Add your own implementation of ROThumbnailGenerator to the ROThumbnail class
     It does automatically add the supported extensions in the internal dictionary and make therefor
     the new genorator accessible for the getThumbnail methods
     
     - parameter thumbnailGenerator:ROThumbnailGenerator: The ROThumbnailGenerator implementation you want to add
     */
    open func addThumbnailGenerator(_ thumbnailGenerator:ROThumbnailGenerator) {
        for fileExtension in thumbnailGenerator.supportedExtensions {
            supportedFiletypes[fileExtension.lowercased()] = thumbnailGenerator
        }
    }
    
    /**
     Analyses the file extension of the given url and uses the corresponding ROThumbnailGenerator
     
     - parameter url:NSURL: Defines the url you want to create a Thumbnail
     - returns: UIImage It does create the created Thumbnail image
     */
    open func getThumbnail(_ url:URL) -> UIImage? {
        let fileExtension = url.pathExtension
        
        let appropriateThumbnailGenerator = supportedFiletypes[fileExtension.lowercased()] ?? DefaultThumbnailGenerator()
        let thumbnail = appropriateThumbnailGenerator.getThumbnail(url)
        
        // Don't perform compression if image quality is set to 100%
        if imageQuality < 1 {
            // Image quality of the thumbnail is defined in the imageQuality variable, can be setted from outside
            if let jpeg = thumbnail.jpegData(compressionQuality: imageQuality) {
                if let img = UIImage(data: jpeg) {
                    return img
                } else {
                    return #colorLiteral(red: 0.9921568627, green: 0.3607843137, blue: 0.3607843137, alpha: 1).image()
                }
            } else {
                return #colorLiteral(red: 0.9921568627, green: 0.3607843137, blue: 0.3607843137, alpha: 1).image()
            }
        }
        
        
        return thumbnail
    }
    
    open func getMediaType(_ url: URL) -> MediaType {
        
        let fileExtension = url.pathExtension
        
        let gen = supportedFiletypes[fileExtension.lowercased()] ?? DefaultThumbnailGenerator()
        switch gen {
        case is ImageThumbnailGenerator:
            return MediaType.Image
        case is PDFThumbnailGenerator:
            return MediaType.Document
        case is TextThumbnailGenerator:
            return MediaType.Document
        case is VideoThumbnailGenerator:
            return MediaType.Video
        case is DefaultThumbnailGenerator:
            return MediaType.Unknown
        default:
            return MediaType.Unknown
        }
    }
}
