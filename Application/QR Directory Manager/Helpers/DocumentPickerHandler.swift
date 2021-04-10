//
//  DocumentPickerHandler.swift
//  QR Directory Manager
//


import Foundation
import UIKit
import MobileCoreServices

class DocumentPickerHandler: NSObject {
    
    static let shared = DocumentPickerHandler()
    
    fileprivate var currentVC: UIViewController!
    
    var docPickedBlock: ((URL, Data) -> Void)?
    
    func showController(vc: UIViewController, view: UIView) {
        currentVC = vc
        let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String, kUTTypeText as String, "com.microsoft.word.docx", "org.openxmlformats.wordprocessingml.document", "com.microsoft.word.pptx", "com.microsoft.word.xlxl"], in: UIDocumentPickerMode.import)
        importMenu.popoverPresentationController?.sourceView = view
        importMenu.delegate = self
        currentVC.present(importMenu, animated: true, completion: nil)
    }
}

extension DocumentPickerHandler : UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        currentVC.dismiss(animated: true, completion: nil)
        for url in urls {
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                self.docPickedBlock?(url, data)
            } catch {}
            
            break
        }
    }
}
