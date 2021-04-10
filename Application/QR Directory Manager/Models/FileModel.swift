//
//  FileModel.swift
//  QR Directory Manager
//


import Foundation

struct FileModel {
    
    var fileName: String
    var fileUrl: URL!
    var fileType: String
    var fileDate: Date
    var fileSize: Int64
    
    init() {
        self.fileName = ""
        self.fileType = ""
        self.fileDate = Date()
        self.fileSize = 0
    }
}
