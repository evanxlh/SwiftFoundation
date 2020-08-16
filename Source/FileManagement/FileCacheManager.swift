//
//  FileCacheManager.swift
//
//  Created by Evan Xie on 2019/3/31.
//

import Foundation

/// `FileCacheManager` can help you to manage the app file caches.
///
/// `FileCacheManager` regards below two directories as caches by default:
///    - NSTemporaryDirectory()
///    - NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
///
/// You can also set your custom directories for your app caches.
public final class FileCacheManager {
    
    private var cacheDirectoryURLs: [URL]
    
    public init(cacheDirectoryURLs: [URL]? = nil) {
        if cacheDirectoryURLs == nil {
            self.cacheDirectoryURLs = [FileManager.tempDirectoryURL, FileManager.cachesDirectoryURL]
        } else {
            self.cacheDirectoryURLs = [URL]()
            self.cacheDirectoryURLs.append(contentsOf: cacheDirectoryURLs!)
        }
    }
    
    /// Add a file cache directory to let `FileCacheManager` manage.
    public func addCacheDirectory(_ directoryURL: URL) {
        if !cacheDirectoryURLs.contains(directoryURL) {
            cacheDirectoryURLs.append(directoryURL)
        }
    }
    
    /// Calucate total size in bytes of managed caches.
    /// All the files and directories under the cache directories are both taken into account.
    ///
    /// - Note: This can be time-consuming, you can use second thread to run this task.
    public func calculateTotalCahceSize() -> UInt64 {
        var cacheSize: UInt64 = 0
        for url in cacheDirectoryURLs {
            cacheSize += FileManager.directorySizeAtURL(url)
        }
        return cacheSize
    }
    
    /// Clear all cache files which `FileCacheManager` manages on the current thread.
    ///
    /// - Note: This can be time-consuming, you can use second thread to run this task.
    public func clearAllCaches(_ includingCacheDirectoriesSelves: Bool = false) {
        if includingCacheDirectoriesSelves {
            cacheDirectoryURLs.forEach {
                try? FileManager.default.removeItem(at: $0)
            }
            return
        }
        
        for directoryURL in cacheDirectoryURLs {
            FileCacheManager.clearOneCahceDirectory(directoryURL)
        }
    }
    
    /// Clear files under `tmp` directory: NSTemporaryDirectory().
    ///
    /// - Note: This can be time-consuming, you can use second thread to run this task.
    public static func clearTempDirectory() {
        clearOneCahceDirectory(FileManager.tempDirectoryURL)
    }
}

fileprivate extension FileCacheManager {
    
    static func clearOneCahceDirectory(_ directoryURL: URL) {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
            urls.forEach { try? FileManager.default.removeItem(at: $0) }
        } catch {
            print("Clear cahce directory failed: \(error)")
        }
    }
}
