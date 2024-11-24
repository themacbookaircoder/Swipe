//
//  Product.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation
import SwiftData

@Model
final public class Products: Codable, Hashable, ObservableObject {
    
    @Attribute(.unique) public var id: UUID = UUID()
    var image: String?
    var price: Double?
    var productName: String?
    var productType: String?
    var tax: Double?
    
    @Transient @Published var favorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case image, price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
    
    required init() {}
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price)
        self.productName = try container.decodeIfPresent(String.self, forKey: .productName)
        self.productType = try container.decodeIfPresent(String.self, forKey: .productType)
        self.tax = try container.decodeIfPresent(Double.self, forKey: .tax)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
        try container.encode(price, forKey: .price)
        try container.encode(productName, forKey: .productName)
        try container.encode(productType, forKey: .productType)
        try container.encode(tax, forKey: .tax)
    }
}
