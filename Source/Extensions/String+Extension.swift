//
//  String+Extension.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 8/16/20.
//

import Foundation

//MARK: - URL Path Operations

public extension String {
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    func appendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    func appendingPathExtension(_ pathExtension: String) -> String? {
        return (self as NSString).appendingPathExtension(pathExtension)
    }
    
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    func toFileURL(isDirectory: Bool = false) -> URL {
        return URL(fileURLWithPath: self, isDirectory: isDirectory)
    }
}
