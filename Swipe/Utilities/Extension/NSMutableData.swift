//
//  NSMutableData.swift
//  Swipe
//
//  Created by Kuldeep on 24/11/24.
//

import Foundation

public extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
