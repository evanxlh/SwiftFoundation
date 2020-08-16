//
//  ConsoleLogger.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 8/16/20.
//

import Foundation

public struct Logger {
    
    public static func debug<T>(_ message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        print("[Debug] [\((file as NSString).lastPathComponent): \(method)] \(message)")
        #endif
    }
    
    public static func error<T>(_ message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        print("[Error] [\((file as NSString).lastPathComponent): \(method)] \(message)")
        #endif
    }
    
    public static func info<T>(_ message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        print("[Info] [\((file as NSString).lastPathComponent): \(method)] \(message)")
        #endif
    }
    
    public static func warning<T>(_ message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        print("[Warning] [\((file as NSString).lastPathComponent): \(method)] \(message)")
        #endif
    }
    
    public static func tag<T>(_ tag: String, message: T, file: String = #file, method: String = #function) {
        #if DEBUG
        print("[\(tag)] [\((file as NSString).lastPathComponent): \(method)] \(message)")
        #endif
    }
}
