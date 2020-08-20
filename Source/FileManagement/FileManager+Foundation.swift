//
//  FileManager+Foundation.swift
//
//  Created by Evan Xie on 2019/3/29.
//

import Foundation

//MARK: - Common use case

public extension FileManager {
    
    typealias FileURLFilter = (_ fileURL: URL, _ isDirectory: Bool) -> Bool
    
    static var documentsDirectoryURL: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    }
    
    static var applicationSupportDirectoryURL: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)[0])
    }
    
    static var cachesDirectoryURL: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])
    }
    
    static var libraryDirectoryURL: URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0])
    }
    
    static var tempDirectoryURL: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    /// Scanning the file urls under the given directory.
    ///
    /// - Parameters:
    ///    - directoryURL: The directory you want to scan.
    ///    - filter: Filter is used to ignore the file urls you don't want.
    ///    - options: see `FileManager.DirectoryEnumerationOptions`
    static func fileURLs(atDirectoryURL directoryURL: URL,
                         filter: FileURLFilter? = nil,
                         options: FileManager.DirectoryEnumerationOptions = .skipsHiddenFiles) -> [URL] {
        
        let key = URLResourceKey.isDirectoryKey
        guard let enumerator = `default`.enumerator(at: directoryURL, includingPropertiesForKeys: [key], options: options, errorHandler: nil) else {
            return []
        }
        
        var fileURLs = [URL]()
        while let url = enumerator.nextObject() as? URL {
            guard let urlFilter = filter else {
                fileURLs.append(url)
                continue
            }
            
            guard let values = try? url.resourceValues(forKeys: Set<URLResourceKey>(arrayLiteral: key)),
                let isDirectory = values.isDirectory,
                urlFilter(url, isDirectory) else {
                    continue
            }
            fileURLs.append(url)
        }
        
        return fileURLs
    }
}

//MARK: - File/Directory URL Maker

public extension FileManager {
    
    /// Make an unique filename.
    static func uniqueFileName(pathExtension: String? = nil) -> String {
        if let ext = pathExtension, !ext.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return NSUUID().uuidString + "." + ext
        } else {
            return NSUUID().uuidString
        }
    }
    
    /// Make an unique temp file url with given path extension under the `NSTemporaryDirectory()`.
    static func uniqueFileURLInTemporaryDirectory(pathExtension: String? = nil) -> URL {
        let filename = uniqueFileName(pathExtension: pathExtension)
        let path = (NSTemporaryDirectory() as NSString).appendingPathComponent(filename)
        return URL(fileURLWithPath: path, isDirectory: false)
    }
    
    /// Make a temp file url with given file name under the `NSTemporaryDirectory()`.
    static func fileURLInTemporaryDirectory(filename: String) -> URL {
        return tempDirectoryURL.appendingPathComponent(filename)
    }
}

// MARK: - File Size & Disk Free Space

public extension FileManager {
    
    /// Get the file size for given file url.
    ///
    /// - Important: If given file url is directory, the file size is 0.
    static func fileSizeAtURL(_ fileURL: URL) -> UInt64 {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: fileURL.path) else { return 0 }
        guard let fileSize = attrs[FileAttributeKey.size] as? UInt64 else { return 0 }
        return fileSize
    }
    
    /// Calculate the directory size, including all the files under the given directory url.
    ///
    /// - Important: If given directory url is a regular file, return 0.
    static func directorySizeAtURL(_ directoryURL: URL) -> UInt64 {
        guard let enumerator = FileManager.default.enumerator(at: directoryURL, includingPropertiesForKeys: nil) else {
            return 0
        }
        
        var totalSize: UInt64 = 0
        while let url = enumerator.nextObject() as? URL {
            guard let attrs = try? FileManager.default.attributesOfItem(atPath: url.path) else { continue }
            guard let fileType = attrs[FileAttributeKey.type] as? FileAttributeType else { continue }
            guard fileType == .typeRegular else { continue }
            guard let fileSize = attrs[FileAttributeKey.size] as? UInt64 else { continue }
            totalSize += fileSize
        }
        return totalSize
    }
    
    /// Get current disk space usage.
    static func diskSpaceUsage() throws -> SpaceUsage {
        let attrs = try FileManager.default.attributesOfFileSystem(forPath: "/")
        let free = attrs[FileAttributeKey.systemFreeSize] as! UInt64
        let total = attrs[FileAttributeKey.systemSize] as! UInt64
        return SpaceUsage(free: free, total: total)
    }
}
