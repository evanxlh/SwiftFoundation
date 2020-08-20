//
//  DispatchTimer.swift
//  SwiftFoundation
//
//  Created by Evan Xie on 2020/8/20.
//

import Foundation

/// A timer wrapper for `DispatchSourceTimer`.
public class DispatchTimer {
    
    private var timer: DispatchSourceTimer?
    private var isInvalidated: Bool {
        return timer == nil
    }
    private var isRunning = false
    
    public init(flags: DispatchSource.TimerFlags = [], queue: DispatchQueue = .main) {
        timer = DispatchSource.makeTimerSource(flags: flags, queue: queue)
    }
    
    public func schedule(withTimeInterval interval: TimeInterval, repeats: Bool, handler: @escaping (_ timer: DispatchTimer) -> Void) {

        guard !isInvalidated else {
            print("Warning: DispatchTimer has already invalidated, please create a new one")
            return
        }
        
        guard !isRunning else {
            print("Warning: DispatchTimer has already scheduled.")
            return
        }
        
        isRunning = true
        
        if repeats {
            timer?.schedule(deadline: .now() + interval, repeating: interval)
        } else {
            timer?.schedule(deadline: .now() + interval, repeating: Double.infinity)
        }
        
        timer?.setEventHandler { [weak self] in
            guard let `self` = self else { return }
            if !repeats {
                self.invalidate()
            }
            handler(self)
        }
        timer?.resume()
    }
    
    public func invalidate() {
        guard let timer = self.timer, !timer.isCancelled else {
            return
        }
        self.timer?.cancel()
        self.timer = nil
        self.isRunning = false
    }
}
