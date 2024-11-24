//
//  String+Extension.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

extension String {
    
    func asUrl() throws -> URL {
        guard let url = URL(string: self) else {
            throw NetworkError.invalidUrl
        }
        return url
    }
    
    func toDouble(defaultValue: Double = 0.0) -> Double {
        return Double(self) ?? defaultValue
    }
}
