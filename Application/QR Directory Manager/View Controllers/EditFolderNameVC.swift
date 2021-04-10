//  Amir Malek 2020
//  EditFolderNameVC.swift
//  QR Directory Manager
//


import UIKit

class EditFolderNameVC: UIViewController {

    @IBOutlet weak var nameText: UITextField!

    var folderName: String!
    var folderPlaceholderName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressedCancelButton))
        self.navigationItem.leftBarButtonItem = cancel
        
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didPressedSaveButton))
        self.navigationItem.rightBarButtonItem = save
    }
    
    func initFolderName(u: String, p: String) {
        folderName = u
        folderPlaceholderName = p
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Edit Folder Name"
        self.nameText.text = folderPlaceholderName
    }

    @objc func didPressedCancelButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didPressedSaveButton() {
        let text = nameText.text ?? ""
        if text.isEmpty {
            return
        }
        nameText.resignFirstResponder()
        UserDefaults.standard.setValue(text, forKey: folderName)
        self.navigationController?.popViewController(animated: true)
    }
}
