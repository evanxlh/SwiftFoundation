//
//  Integer+Extension.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 2020/7/23.
//

import Foundation

extension Int8 {
    
    func toUnsignedValue() -> UInt8 {
        if self >= 0 {
            return UInt8(self)
        }
        
        // 小于 0, 取补码
        var complement = UInt8(-self)
        complement = ~complement
        return complement + 1
    }
}

extension UInt8 {
    
    func toSignedValue() -> Int8 {
        if self > 127 {
            let complement = ~self
            return -Int8(complement + 1)
        }
        
        // <= 127
        return Int8(self)
    }
}
