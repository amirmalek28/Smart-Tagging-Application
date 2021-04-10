//
//  FolderCell.swift
//  QR Directory Manager
//


import UIKit

class FolderCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var count: UILabel!
    
    func updateViews(model: FolderModel) {
        name.text = model.folderName
        
        if let orn = UserDefaults.standard.value(forKey: model.folderName) as? String {
            name.text = orn
        }
        
        count.text = model.folderCount + " Files"
        date.text = "Created at " + Constants.formatDate("dd-MM-yyyy", dt: model.folderDate)
    }
    
}
