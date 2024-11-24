//
//  ProductRequestEntity.swift
//  Swipe
//
//  Created by Kuldeep on 24/11/24.
//

import Foundation
import SwiftData

@Model
class ProductRequestEntity {
    var productName: String
    var productType: String
    var price: Double
    var tax: Double

    init(productName: String, productType: String, price: Double, tax: Double) {
        self.productName = productName
        self.productType = productType
        self.price = price
        self.tax = tax
    }
}
