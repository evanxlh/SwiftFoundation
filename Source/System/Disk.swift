//
//  Disk.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 8/16/20.
//

import Foundation

public struct Disk {
    
    public static func fetchCurrentUsage() throws -> SpaceUsage {
        let attrs = try FileManager.default.attributesOfFileSystem(forPath: "/")
        let free = attrs[FileAttributeKey.systemFreeSize] as! UInt64
        let total = attrs[FileAttributeKey.systemSize] as! UInt64
        return SpaceUsage(free: free, total: total)
    }
}
