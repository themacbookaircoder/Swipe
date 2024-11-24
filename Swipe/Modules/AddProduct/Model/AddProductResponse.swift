//
//  AddProductResponse.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

// MARK: - Product
struct AddProductResponse: Codable {
    let message: String?
    let productDetails: ProductDetails?
    let productID: Int?
    let success: Bool?

    enum CodingKeys: String, CodingKey {
        case message
        case productDetails = "product_details"
        case productID = "product_id"
        case success
    }
}

// MARK: - ProductDetails
struct ProductDetails: Codable {
    let image: String?
    let price: Int?
    let productName, productType: String?
    let tax: Double?

    enum CodingKeys: String, CodingKey {
        case image, price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}
