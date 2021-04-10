//
//  FoldersVC.swift
//  QR Directory Manager
//


import UIKit

class FoldersVC: UIViewController {

    @IBOutlet weak var foldersTable: UICollectionView!
    
    var foldersList = [FolderModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foldersTable.delegate = self
        foldersTable.dataSource = self
        foldersTable.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didPressedTableViewCell(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Folders"
        loadData()
    }
    
    func loadData() {
        self.foldersList.removeAll(); self.foldersTable.reloadData()
        let fileManager = FileManager.default
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let dUrl = NSURL.fileURL(withPath: documentsPath)

            let fileURLs = try fileManager.contentsOfDirectory(atPath: dUrl.path)
            for fileName in fileURLs {
                let fileURL = dUrl.appendingPathComponent(fileName)
                
                let fileAttribute = try fileManager.attributesOfItem(atPath: fileURL.path)
                let date = fileAttribute[FileAttributeKey.creationDate] as? Date ?? Date()

                let contents = try fileManager.contentsOfDirectory(atPath: fileURL.path)
                
                var model = FolderModel()
                model.folderName = fileName
                model.folderCount = String(contents.count)
                model.folderDate = date
                
                self.foldersList.append(model)
                self.foldersTable.reloadData()
            }
        } catch {
            print("Error while enumerating files): \(error.localizedDescription)")
        }
    }

    @objc func didPressedTableViewCell(_ sender: UILongPressGestureRecognizer) {
        if (sender.state != UIGestureRecognizer.State.ended){
            return
        }

        let p = sender.location(in: self.foldersTable)
        if let index = self.foldersTable.indexPathForItem(at: p) {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this Folder?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                let model = self.foldersList[index.item]
                self.deleteFolderFrom(folder: model)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension FoldersVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foldersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = foldersList[indexPath.item]
        let vc = AppStoryboard.Main.shared.instantiateViewController(withIdentifier: FolderFilesVC.storyboard_id) as? FolderFilesVC
        vc?.initFolderName(u: model.folderName)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCell.identifier, for: indexPath) as? FolderCell {
            cell.updateViews(model: foldersList[indexPath.item])
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func deleteFolderFrom(folder: FolderModel) {
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let directoryPath = documentsPath + "/" + folder.folderName
            let dUrl = NSURL.fileURL(withPath: directoryPath)

            try FileManager.default.removeItem(at: dUrl)
            self.loadData()
        } catch {
            AlertBuilder().buildToast(vc: self, message: "Failed to delete Folder\nError: " + error.localizedDescription)
        }
    }
}
