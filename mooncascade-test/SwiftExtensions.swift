//
//  SwiftExtensions.swift
//  mooncascade-test
//
//  Created by Dmitry Kanivets on 18.04.18.
//  Copyright © 2018 Dmitry Kanivets. All rights reserved.
//

import Foundation

extension Array {
    
    func failableMap<U>(_ transform: (Element) -> U?) -> [U]? {
        return self.map(transform).reduce([U]()) { p, n -> [U]? in
            if let previous = p, let next = n {
                return previous + [next]
            } else {
                return nil
            }
        }
    }
}

// MARK: Dispatch time in seconds

func dispatchAfter(seconds: Double, queue: DispatchQueue = DispatchQueue.main, block: @escaping ()->()) {
    queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
}
