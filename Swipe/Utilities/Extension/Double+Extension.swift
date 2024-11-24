//
//  Double+Extension.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

extension Double {
    
    func toString(decimalPlaces: Int = 2) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}

