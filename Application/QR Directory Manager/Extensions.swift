//
//  Extensions.swift
//  QR Directory Manager
//


import Foundation
import UIKit

enum AppStoryboard : String {
    case Main, Profile
    var shared : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}

extension UIViewController {
    class var storyboard_id : String {
        return "\(self)"
    }
}

extension UITableViewCell {
    class var identifier: String {
        return "\(self)"
    }
}

extension UICollectionViewCell {
    class var identifier: String {
        return "\(self)"
    }
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
