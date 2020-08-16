//
//  DispatchQueue+Foundation.swift
//
//  Created by Evan Xie on 2019/3/29.
//

import Dispatch

public extension DispatchQueue {
    
    /// A boolean value indicating whether the current running dispatch queue is main.
    static var isMain: Bool {
        return DispatchQueue.isCurrent(DispatchQueue.main)
    }
    
    /// A boolean value indicating whether the given dispatch queue is the current running dispatch queue.
    static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<UInt32>()
        queue.setSpecific(key: key, value: arc4random())
        defer { queue.setSpecific(key: key, value: nil) }
        
        return DispatchQueue.getSpecific(key: key) != nil
    }
    
    /// Running block on the queue synchronously without deadlock.
    func syncSafely(_ block: @escaping () -> Void) {
        if DispatchQueue.isCurrent(self) {
            block()
        } else {
            sync { block() }
        }
    }
}
