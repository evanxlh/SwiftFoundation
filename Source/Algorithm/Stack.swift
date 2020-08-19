//
//  Stack.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 8/19/20.
//

import Foundation

/// A simpe stack for push and pop element.
///
/// - Important: This stack is not thread-safe.
public class Stack<T>: CustomDebugStringConvertible {

    fileprivate var head: Node<T>?
    fileprivate var _size: Int
    
    /// The number of elements in the stack.
    public var size: Int {
        return _size
    }
    
    /// When there is 0 element in the stack, it's an empty stack.
    public var isEmpty: Bool {
        return _size == 0
    }
    
    /// The elment on the top of stack.
    public var topElement: T? {
        return head?.value
    }
    
    public init() {
        _size = 0
        head = nil
    }
    
    /// Push an element on the top of stack, the size of stack will increase one.
    public func push(_ element: T) {
        let newNode = Node(value: element)
        if head == nil {
            head = newNode
        } else {
            head?.next = newNode
            newNode.previous = head
            head = newNode
        }
        
        _size += 1
    }
    
    /// Pop an element from the top of stack, the size of stack will decrease one.
    @discardableResult
    public func pop() -> T? {
        guard head != nil else {  return nil }
        
        let element = head?.value
        head = head?.previous
        head?.next = nil
        if size > 0 {
            _size -= 1
        }
        return element
    }
    
    /// Pop all the elements from stack.
    @discardableResult
    public func popAll() -> [T] {
        var elements = [T]()
        while let e = pop() {
            elements.append(e)
        }
        return elements
    }
    
    /// Enumerate all the elements in the stack, from top to bottom of stack.
    public func enumerate(_ block: (_ element: T, _ index: Int) -> Void) {
        guard head != nil else { return }
        
        var index: Int = 0
        block(head!.value, index)
        
        var previous: Node? = head?.previous
        while previous != nil {
            index += 1
            block(previous!.value, index)
            previous = previous?.previous
        }
    }
    
    public var debugDescription: String {
        var string = "Stack: [\n"
        enumerate { (e, index) in
            if index != _size - 1 {
                string += "  \(e),\n"
            } else {
                string += "  \(e)"
            }
        }
        string += "\n]"
        return string
    }
}

fileprivate class Node<T> {
    var value: T
    weak var next: Node<T>? = nil
    var previous: Node<T>? = nil
    
    init(value: T) {
        self.value = value
    }
}
