//
//  ProductRequest.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

struct ProductRequest: Encodable {
    var productName: String
    var productType: String
    var price: Double
    var tax: Double
//    var files: [MultipartFormData]?

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productType = "product_type"
        case price
        case tax
//        case files
    }
}
