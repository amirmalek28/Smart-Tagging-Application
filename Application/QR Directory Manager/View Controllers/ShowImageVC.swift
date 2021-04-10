//
//  ShowImageVC.swift
//  QR Directory Manager
//


import UIKit
import ImageScrollView

class ShowImageVC: UIViewController {

    @IBOutlet weak var imageView: ImageScrollView!
    
    var imageUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.setup()
        
        let share = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didPressedShareButton))
        self.navigationItem.rightBarButtonItem = share
    }
    
    @objc func didPressedShareButton() {
        if let url = imageUrl {
            do {
                let data = try Data(contentsOf: url)
                if let img = UIImage(data: data) {
                    let imageToShare = [ img ] as [Any]
                    let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    self.present(activityViewController, animated: true, completion: nil)
                }
            } catch { }
        }
    }
    
    func initImageUrl(url: URL) {
        self.imageUrl = url
    }

    override func viewWillAppear(_ animated: Bool) {
        if let url = imageUrl {
            do {
                let data = try Data(contentsOf: url)
                if let img = UIImage(data: data) {
                    self.imageView.imageContentMode = .widthFill
                    self.imageView.display(image: img)
                }
            } catch { }
        }
    }
}
