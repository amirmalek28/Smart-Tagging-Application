//
//  MainVC.swift
//  QR Directory Manager
//


import UIKit
import MTBBarcodeScanner

class MainVC: UIViewController {

    @IBOutlet weak var torchBtn: UIButton!
    @IBOutlet weak var switchCameraBtn: UIButton!
    
    var scanner: MTBBarcodeScanner!
    var uniqueCodes: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanner = MTBBarcodeScanner(previewView: self.view)

        torchBtn.addTarget(self, action: #selector(torchBtnPressed), for: .touchUpInside)
        switchCameraBtn.addTarget(self, action: #selector(cameraBtnPressed), for: .touchUpInside)
        
        let files = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(didPressedFolderButton))
        self.navigationItem.rightBarButtonItem = files
    }
    
    @objc func didPressedFolderButton() {
        let view = AppStoryboard.Main.shared.instantiateViewController(withIdentifier: FoldersVC.storyboard_id)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Scan"
        self.uniqueCodes.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MTBBarcodeScanner.requestCameraPermission(success: { success in
            if success {
                do {
                    try self.scanner.startScanning(resultBlock: { codes in
                        if let codes = codes {
                            for code in codes {
                                let stringValue = code.stringValue
                                if let val = stringValue {
                                    let value = self.uniqueCodes.index(of: val)
                                    if value == nil {
                                        if !val.isEmpty {
                                            if self.createFolder(folderName: val) != nil {
                                                self.uniqueCodes.append(val)
                                                let vc = AppStoryboard.Main.shared.instantiateViewController(withIdentifier: FolderFilesVC.storyboard_id) as? FolderFilesVC
                                                vc?.initFolderName(u: val)
                                                self.navigationController?.pushViewController(vc!, animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    })
                } catch {
                    print("Unable to start scanning")
                }
            } else {
                AlertBuilder().buildMessage(vc: self, message: "App doesn't have permission to use camera")
            }
        })
    }


    override func viewDidDisappear(_ animated: Bool) {
        self.scanner.stopScanning()
    }
    
    @objc func torchBtnPressed() {
        if self.scanner.hasTorch() {
            self.scanner.toggleTorch()
            if(self.scanner.torchMode == .on) {
                torchBtn.setImage(#imageLiteral(resourceName: "torch_on"), for: .normal)
            } else {
                torchBtn.setImage(#imageLiteral(resourceName: "torch_off"), for: .normal)
            }
        } else {
            AlertBuilder().buildMessage(vc: self, message: "No Torch Available")
        }
    }
    
    @objc func cameraBtnPressed() {
        
        do {
            if(self.scanner.torchMode == .on && self.scanner.camera == .back) {
                self.scanner.toggleTorch()
            }
            try self.scanner.flipCameraWithError()
            torchBtn.setImage(#imageLiteral(resourceName: "torch_off"), for: .normal)
        } catch  {
            AlertBuilder().buildMessage(vc: self, message: "Error \(error.localizedDescription)")
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
}
