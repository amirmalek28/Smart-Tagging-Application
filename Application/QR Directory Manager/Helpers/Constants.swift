//
//  Constants.swift
//  QR Directory Manager
//


import Foundation

class Constants {
    
    static func getCurrentMillis() -> String {
        return String(Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    static func formatDate(_ fm: String, dt: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = fm
        return df.string(from: dt)
    }
}
