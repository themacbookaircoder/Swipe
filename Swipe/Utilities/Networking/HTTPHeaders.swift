//
//  HTTPHeaders.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

enum HTTPHeaderKeys: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum HTTPHeaderValues: String {
    case json = "Application/json"
    case form = "multipart/form-data"
}
