//  Amir Malek 2020
//  ViewController.swift
//  QR Directory Manager
//


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didPressedCreateBtn(_ sender: UIButton) {
        if let t = nameText.text {
            if createFolder(folderName: t) != nil {
                let vc = AppStoryboard.Main.shared.instantiateViewController(withIdentifier: FolderFilesVC.storyboard_id) as? FolderFilesVC
                vc?.initFolderName(u: t)
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
    }
    
    func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
    
    @IBAction func didPressedViewBtn(_ sender: UIButton) {
        let view = AppStoryboard.Main.shared.instantiateViewController(withIdentifier: FoldersVC.storyboard_id)
        self.navigationController?.pushViewController(view, animated: true)
    }
}

