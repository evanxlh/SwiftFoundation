//
//  Tests.swift
//  Tests
//
//  Created by Evan Xie on 8/19/20.
//

import XCTest
@testable import SwiftFoundation

fileprivate class StringContent {
    let value: String
    init(_ value: String) {
        self.value = value
    }
    deinit {
        print("deinit \(value)")
    }
}

class StackTests: XCTestCase {

    private let stack = Stack<StringContent>()

    override func setUpWithError() throws {
        stack.push(StringContent("A"))
        stack.push(StringContent("B"))
    }

    override func tearDownWithError() throws {
        
    }

    func testPushPopStack() throws {
        
        stack.push(StringContent("C"))
        XCTAssertTrue(stack.topElement?.value == "C")
        
        stack.push(StringContent("D"))
        XCTAssertTrue(stack.topElement?.value == "D")
        
        XCTAssertTrue(stack.size == 4)
        
        var element = stack.pop()
        XCTAssertTrue(element?.value == "D")
        XCTAssertTrue(stack.topElement?.value == "C")
        
        element = stack.pop()
        XCTAssertTrue(element?.value == "C")
        XCTAssertTrue(stack.topElement?.value == "B")
        
        let elements = stack.popAll()
        XCTAssertTrue(elements.count == 2)
        XCTAssertTrue(stack.size == 0)
    }

    func testStackEnumeration() throws {
        stack.enumerate { (element, index) in
            if index == 0 {
                XCTAssertTrue(element.value == "B")
            } else if index == 1 {
                XCTAssertTrue(element.value == "A")
            }
        }
    }

}
