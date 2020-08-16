//
//  TimeProfiler.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 2019/3/29.
//

import Foundation

/**
 TimeProfiler is designed for measuring time cost of a long time task.
 
 Usage one example:
 ```
 let timeProfiler = TimeProfiler()
 timeProfiler.begin()
 doYourTask()
 timeProfiler.end()
 timeProfiler.printDebugString()
 ```
 
 Usage two example:
 ```
 let timeProfiler = TimeProfiler.measure {
    doYourTask()
 }
 timeProfiler.printDebugString()
 ```
 */
public final class TimeProfiler {
    
    private var beginTimestamp: CFAbsoluteTime = 0.0
    private var endTimestamp: CFAbsoluteTime = 0.0
    
    public var timeCost: CFAbsoluteTime {
        return endTimestamp - beginTimestamp
    }
    
    public let name: String
    
    public init(name: String = "Task") {
        self.name = name
        beginTimestamp = 0
        endTimestamp = 0
    }
    
    public func begin() {
        beginTimestamp = CFAbsoluteTimeGetCurrent()
    }
    
    public func end() {
        endTimestamp = CFAbsoluteTimeGetCurrent()
    }
    
    public func printDebugString() {
        Logger.debug("[\(name)] time cost: \(timeCost)s.")
    }
}

public extension TimeProfiler {
    
    static func measure(_ block: () -> Void) -> TimeProfiler {
        let profiler = TimeProfiler(name: "Block")
        profiler.begin()
        block()
        profiler.end()
        return profiler
    }
}
