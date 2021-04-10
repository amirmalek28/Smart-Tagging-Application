//
//  AlertBuilder.swift
//  QR Directory Manager
//

import Foundation
import UIKit

class AlertBuilder {
    
    var pressedOk: (() -> Void)?
    
    func buildMessage(vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true)
    }
    
    func buildMessageWithCallback(vc: UIViewController, message: String) {
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.pressedOk?()
        }))
        
        vc.present(alert, animated: true)
    }
    
    func buildToast(vc: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        vc.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            alert.dismiss(animated: true)
        }
    }
}
