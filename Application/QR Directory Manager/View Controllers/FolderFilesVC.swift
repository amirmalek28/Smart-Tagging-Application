//  Amir Malek 2020
//  FolderFilesVC.swift
//  QR Directory Manager
//

import UIKit
import AVFoundation
import AVKit
import QuickLook

class FolderFilesVC: UIViewController {

    @IBOutlet weak var filesCollection: UICollectionView!
    
    var filesList = [FileModel]()
    
    lazy var previewItem = NSURL()

    var folderName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressedAddButton))
    
        let edit = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didPressedEditButton))
        self.navigationItem.rightBarButtonItems = [add, edit]
        
        filesCollection.delegate = self
        filesCollection.dataSource = self
        filesCollection.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(didPressedCollectionViewCell(_:))))
        
        loadData()
    }

    func initFolderName(u: String) {
        folderName = u
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = folderName
        
        if let orn = UserDefaults.standard.value(forKey: folderName) as? String {
            self.navigationItem.title = orn
        }
    }
    
    @objc func didPressedEditButton() {
        let edit = AppStoryboard.Main.shared.instantiateViewController(withIdentifier: EditFolderNameVC.storyboard_id) as? EditFolderNameVC
        var name = folderName ?? ""
        if let t = self.navigationItem.title {
            name = t
        }
        edit?.initFolderName(u: folderName, p: name)
        self.navigationController?.pushViewController(edit!, animated: true)
    }
    
    @objc func didPressedAddButton() {
        let actions = UIAlertController(title: nil, message: "Choose an Option", preferredStyle: .actionSheet)
        actions.addAction(UIAlertAction(title: "Image", style: .default, handler: { (action) in
            CameraHandler.shared.showActionSheet(vc: self, view: self.view)
            CameraHandler.shared.imagePickedBlock = { (url, data) in
//                print(url.lastPathComponent)
                //FA66EC8B-B7F3-42E2-B8D7-86938BDC7E71
                //0ABA689A-DDE5-48CC-9D23-6C4F2E65E667
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let directoryPath = documentsPath + "/" + self.folderName + "/"
                var endName = Constants.getCurrentMillis() + ".jpeg"
                if let u = url {
                    endName = u.lastPathComponent
                }
                let filePath = directoryPath + endName
                let dUrl = NSURL.fileURL(withPath: directoryPath)

                do {
                    try FileManager.default.createDirectory(at: dUrl, withIntermediateDirectories: true, attributes: nil)
                    FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
                } catch {
                    AlertBuilder().buildMessage(vc: self, message: "Failed to add Image\nError: " + error.localizedDescription)
                }

                self.loadData()
            }
        }))
        actions.addAction(UIAlertAction(title: "Video", style: .default, handler: { (action) in
            VideoPickerHandler.shared.showActionSheet(vc: self, view: self.view)
            VideoPickerHandler.shared.videoPickedBlock = {(url, data) in
              
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let directoryPath = documentsPath + "/" + self.folderName + "/"
                let filePath = directoryPath + url.lastPathComponent
                let dUrl = NSURL.fileURL(withPath: directoryPath)
                
                do {
                    try FileManager.default.createDirectory(at: dUrl, withIntermediateDirectories: true, attributes: nil)
                    FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
                }catch {
                    AlertBuilder().buildMessage(vc: self, message: "Failed to add Video\nError: " + error.localizedDescription)
                }
                
                self.loadData()
            }
        }))
        actions.addAction(UIAlertAction(title: "Document", style: .default, handler: { (action) in
            DocumentPickerHandler.shared.showController(vc: self, view: self.view)
            DocumentPickerHandler.shared.docPickedBlock = { (url, data) in
              
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                let directoryPath = documentsPath + "/" + self.folderName + "/"
                let filePath = directoryPath + url.lastPathComponent
                let dUrl = NSURL.fileURL(withPath: directoryPath)
                
                do {
                    try FileManager.default.createDirectory(at: dUrl, withIntermediateDirectories: true, attributes: nil)
                    FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
                }catch {
                    AlertBuilder().buildMessage(vc: self, message: "Failed to add Document\nError: " + error.localizedDescription)
                }
                
                self.loadData()
            }
        }))
        actions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actions, animated: true, completion: nil)
    }
    
    func loadData() {
        self.filesList.removeAll(); self.filesCollection.reloadData()
        let fileManager = FileManager.default
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let directoryPath = documentsPath + "/" + folderName
            let dUrl = NSURL.fileURL(withPath: directoryPath)
            
            let fileURLs = try fileManager.contentsOfDirectory(atPath: dUrl.path)
            for fileName in fileURLs {
                let fileURL = dUrl.appendingPathComponent(fileName)
                
                let fileAttribute = try fileManager.attributesOfItem(atPath: fileURL.path)
                let fileSize = fileAttribute[FileAttributeKey.size] as! Int64
//                let fileType = fileAttribute[FileAttributeKey.type] as! String
                let filecreationDate = fileAttribute[FileAttributeKey.creationDate] as! Date
                let fileExtension = fileURL.pathExtension;

//                print("Name: \(fileName), Size: \(fileSize), Type: \(fileType), Date: \(filecreationDate), Extension: \(fileExtension)")
                
                var model = FileModel()
                model.fileName = fileName
                model.fileSize = fileSize
                model.fileType = fileExtension
                model.fileDate = filecreationDate
                model.fileUrl = fileURL
                
                self.filesList.append(model)
                self.filesCollection.reloadData()
            }
        } catch {
            print("Error while enumerating files): \(error.localizedDescription)")
        }
    }
    
    @objc func didPressedCollectionViewCell(_ sender: UILongPressGestureRecognizer) {
        if (sender.state != UIGestureRecognizer.State.ended){
            return
        }

        let p = sender.location(in: self.filesCollection)
        if let index = self.filesCollection.indexPathForItem(at: p) {
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this file?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                let model = self.filesList[index.item]
                self.deleteFileFrom(file: model)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension FolderFilesVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filesList.count > 0 {
            filesCollection.backgroundView = nil
            return filesList.count
        } else {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
            label.textAlignment = .center
            label.text = "Add Media..."
            label.textColor = .darkText
            filesCollection.backgroundView = label
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        return CGSize(width: width - 5, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = filesList[indexPath.item]
        let type = ROThumbnail.sharedInstance.getMediaType(model.fileUrl)
        switch type {
        case ROThumbnail.MediaType.Video:
            self.presentVideoFile(model: model)
            break
        case ROThumbnail.MediaType.Image:
            self.presentImageFile(model: model)
            break
        case ROThumbnail.MediaType.Document:
            self.presentDocumentFile(model: model)
        default:
            break
        }
    }
    
    func presentImageFile(model: FileModel) {
        let show = AppStoryboard.Main.shared.instantiateViewController(withIdentifier: ShowImageVC.storyboard_id) as? ShowImageVC
        show?.initImageUrl(url: model.fileUrl)
        self.navigationController?.pushViewController(show!, animated: true)
    }
    
    func presentVideoFile(model: FileModel) {
        if let url = model.fileUrl {
            let playerViewController = AVPlayerViewController()
            let videoPlayer = AVPlayer(url: url)
            playerViewController.player = videoPlayer
            self.present(playerViewController, animated: true) {
                if let pl = playerViewController.player {
                    pl.play()
                }
            }
        }
    }
    
    func presentDocumentFile(model: FileModel) {
        if let url = model.fileUrl {
            self.previewItem = url as NSURL
            // Display file
            let previewController = QLPreviewController()
            previewController.dataSource = self
            self.present(previewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderFilesCell.identifier, for: indexPath) as? FolderFilesCell {
            let model = filesList[indexPath.item]
            cell.updateViews(model: model)
            
            DispatchQueue.global().async {
                let img = ROThumbnail.sharedInstance.getThumbnail(model.fileUrl)
                DispatchQueue.main.async {
                    cell.image.image = img
                }
            }
            
            if ROThumbnail.sharedInstance.getMediaType(model.fileUrl) == ROThumbnail.MediaType.Video {
                cell.play.isHidden = false
            } else {
                cell.play.isHidden = true
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func deleteFileFrom(file: FileModel) {
        if let url = file.fileUrl {
            do {
                try FileManager.default.removeItem(at: url)
                self.loadData()
            }catch {
                AlertBuilder().buildToast(vc: self, message: "Failed to delete Item\nError: " + error.localizedDescription)
            }
        }
    }
}

extension FolderFilesVC : QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
}
