//
//  PDFThumbnailGenerator.swift
//  QR Directory Manager
//


import Foundation
import UIKit

class PDFThumbnailGenerator : ROThumbnailGenerator {
    
    var supportedExtensions:Array<String> = ["pdf"]
    
    func getThumbnail(_ url:URL, pageNumber:Int, width:CGFloat) -> UIImage {
        if let pdf:CGPDFDocument = CGPDFDocument(url as CFURL) {
            if let firstPage = pdf.page(at: pageNumber) {
            
                var pageRect:CGRect = firstPage.getBoxRect(CGPDFBox.mediaBox)
                let pdfScale:CGFloat = width/pageRect.size.width
                pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
                pageRect.origin = CGPoint.zero
                
                UIGraphicsBeginImageContext(pageRect.size)
                
                if let context:CGContext = UIGraphicsGetCurrentContext() {
                    
                    // White BG
                    context.setFillColor(red: 1.0,green: 1.0,blue: 1.0,alpha: 1.0)
                    context.fill(pageRect)
                    
                    context.saveGState()
                    
                    // Next 3 lines makes the rotations so that the page look in the right direction
                    context.translateBy(x: 0.0, y: pageRect.size.height)
                    context.scaleBy(x: 1.0, y: -1.0)
                    context.concatenate((firstPage.getDrawingTransform(CGPDFBox.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true)))
                    
                    context.drawPDFPage(firstPage)
                    context.restoreGState()
                    
                    if let thm = UIGraphicsGetImageFromCurrentImageContext() {
                        UIGraphicsEndImageContext();
                        return thm;
                    }
                }
            }
        }
        
        return #colorLiteral(red: 0.9921568627, green: 0.3607843137, blue: 0.3607843137, alpha: 1).image()
    }
    
    func getThumbnail(_ url:URL, pageNumber:Int) -> UIImage {
        return self.getThumbnail(url, pageNumber: pageNumber, width: 240.0)
    }
    
    func getThumbnail(_ url:URL) -> UIImage {
        return self.getThumbnail(url, pageNumber: 1, width: 240.0)
    }
}
