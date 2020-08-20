//
//  Data+TypeConversion.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 2020/6/30.
//

import Foundation

public extension Data {
    
    init<T>(typeInstance: T) {
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        pointer.initialize(to: typeInstance)
        defer {
            pointer.deinitialize(count: 1)
            pointer.deallocate()
        }
        
        let buffer = UnsafeBufferPointer<T>(start: pointer, count: 1)
        self.init(buffer: buffer)
    }
    
    init<T>(typeInstances: [T]) {
        let count = typeInstances.count
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: count)
        pointer.initialize(from: typeInstances, count: count)
        defer {
            pointer.deinitialize(count: count)
            pointer.deallocate()
        }
        self.init(buffer: UnsafeBufferPointer<T>.init(start: pointer, count: count))
    }
    
    func toTypeInstance<T>() -> T {
        return withUnsafeBytes {
            $0.load(as: T.self)
            // 以下这种方式也可以
            // $0.baseAddress?.assumingMemoryBound(to: T.self).pointee
        }
    }
    
    func toTypeInstances<T>() -> [T] {
        let values = withUnsafeBytes { (pointer) -> [T] in
            let buffer = pointer.bindMemory(to: T.self)
            return buffer.map { $0 }
        }
        return values
    }
    
    /// 从二进制数据指定偏移位置读出指定类型的数据。
    ///
    /// `T` 可以为任意类型(如 UInt16, struct 等)，但要注意 Data 的内存分布情况，否则会出现意想不到的问题。
    func readValue<T>(offset: Data.Index) -> T? {
        let maxOffset = count - MemoryLayout<T>.size
        guard Range(0...maxOffset).contains(offset) else {
            return nil
        }
        
        return withUnsafeBytes {
            $0.baseAddress?.advanced(by: offset).assumingMemoryBound(to: T.self).pointee
        }
    }
}
