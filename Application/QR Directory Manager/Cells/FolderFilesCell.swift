//
//  FolderFilesCell.swift
//  QR Directory Manager
//


import UIKit

class FolderFilesCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var play: UIButton!
    
    func updateViews(model: FileModel) {
        date.text = Constants.formatDate("dd-MM-yyyy", dt: model.fileDate)
        type.text = model.fileType.uppercased()
    }
}
