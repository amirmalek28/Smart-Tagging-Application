//
//  VideoPickerHandler.swift
//  QR Directory Manager
//


import Foundation
import UIKit
import MobileCoreServices

class VideoPickerHandler : NSObject {
    
    static let shared = VideoPickerHandler()
    
    fileprivate var currentVC: UIViewController!
    
    var videoPickedBlock: ((URL, Data) -> Void)?
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = [kUTTypeMovie as String]
            myPickerController.allowsEditing = false
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String]
            myPickerController.allowsEditing = false
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController, view: UIView) {
        currentVC = vc
        let actionSheet = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.popoverPresentationController?.sourceView = view
        //        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension VideoPickerHandler : UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        currentVC.dismiss(animated: true, completion: nil)
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! String
        if mediaType == kUTTypeMovie as String {
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                do {
                    let video = try Data(contentsOf: url, options: .mappedIfSafe)
                    self.videoPickedBlock?(url ,video)
                } catch {
                    print(error)
                    return
                }
            }
        }
    }
}

extension VideoPickerHandler : UINavigationControllerDelegate { }
