//
//  Memory.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 8/16/20.
//

import Foundation

/// Fetch current memory state.
public struct Memory {
    
    public struct State: CustomDebugStringConvertible {
        public var freeBytes: UInt64
        public var activeBytes: UInt64
        public var inactiveBytes: UInt64
        public var wiredBytes: UInt64
        public var compressedBytes: UInt64
        public var totalBytes: UInt64
        
        public var debugDescription: String {
            var desc = "Memory Details: [\n"
            desc.append("Free Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(freeBytes), countStyle: .memory)),\n")
            desc.append("Active Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(activeBytes), countStyle: .memory)),\n")
            desc.append("Inactive Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(inactiveBytes), countStyle: .memory)),\n")
            desc.append("Wired Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(wiredBytes), countStyle: .memory)),\n")
            desc.append("Compressed Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(compressedBytes), countStyle: .memory)),\n")
            desc.append("Total Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(totalBytes), countStyle: .memory))\n]")
            return desc
        }
    }
    
    public struct Usage: CustomDebugStringConvertible {
        public var usedBytes: UInt64
        public var totalBytes: UInt64
        
        public var debugDescription: String {
            var desc = "Memory Usage: [\n"
            desc.append("Used Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(usedBytes), countStyle: .memory)),\n")
            desc.append("Total Bytes: \(ByteCountFormatter.string(fromByteCount: Int64(totalBytes), countStyle: .memory))\n]")
            return desc
        }
    }
    
    /// Physic memory in bytes for your device.
    public static func physical() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    /// Current memory usage for your device.
    public static func usage() -> Usage? {
        
        var taskInfo = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size / MemoryLayout<integer_t>.size)
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        guard result == KERN_SUCCESS else {
            let errorString = String(cString: mach_error_string(result), encoding: String.Encoding.ascii) ?? "unknown error"
            print("Collecting used memroy info failed: \(errorString)")
            return nil
        }
        
        return Usage(usedBytes: UInt64(taskInfo.resident_size), totalBytes: physical())
    }
    
    /// Obtain current memory state for your device.
    public static func state() -> State? {
        
        var count: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        let pageSize = natural_t(vm_kernel_page_size)
        
        let statisticsPointer = vm_statistics64_t.allocate(capacity: 1)
        defer { statisticsPointer.deallocate() }
        
        let result = statisticsPointer.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            host_statistics64(mach_host_self(), host_flavor_t(HOST_VM_INFO64), $0, &count)
        }
        
        guard result == KERN_SUCCESS else {
            let errorString = String(cString: mach_error_string(result), encoding: String.Encoding.ascii) ?? "unknown error"
            print("Collecting memroy detail failed: \(errorString)")
            return nil
        }
        
        let statistics: vm_statistics64 = statisticsPointer.move()
        let free = UInt64(statistics.free_count * pageSize)
        let active = UInt64(statistics.active_count * pageSize)
        let inactive = UInt64(statistics.inactive_count * pageSize)
        let wired = UInt64(statistics.wire_count * pageSize)
        let compressed = UInt64(statistics.compressor_page_count * pageSize)
        
        return State(freeBytes: free,
                     activeBytes: active,
                     inactiveBytes: inactive,
                     wiredBytes: wired,
                     compressedBytes: compressed,
                     totalBytes: physical())
    }
}
