//
//  FolderModel.swift
//  QR Directory Manager
//

import Foundation

struct FolderModel {

    var folderName: String
    var folderCount: String
    var folderDate: Date
    
    init() {
        self.folderName = ""
        self.folderCount = "0"
        self.folderDate = Date()
    }
}
