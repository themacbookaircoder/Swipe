//
//  EndPoint.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

enum EndPoint {
    case products
    case addProduct(ProductRequest)
}

extension EndPoint: TargetType {
    var baseURL: String {
        return "https://app.getswipe.in/api"
    }
    
    var path: String {
        switch self {
        case .products:
            return "/public/get"
        case .addProduct:
            return "/public/add"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .products:
            return .get
        case .addProduct:
            return .post
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .products:
            return [HTTPHeaderKeys.contentType.rawValue: HTTPHeaderValues.json.rawValue]
        case .addProduct:
            return nil
        }
    }
    
    var params: RequestParams? {
        switch self {
        case .products:
            return nil
        case .addProduct(let request):
            return .formData(request, [])
        }
    }
}
