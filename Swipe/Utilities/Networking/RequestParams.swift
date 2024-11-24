//
//  RequestParams.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

enum RequestParams {
    case query(_ request: Encodable)
    case body(_ request: Encodable)
    case formData(_ parameters: Encodable, _ files: [MultipartFormData])
}

public struct MultipartFormData {

    public init(data: Data, name: String, fileName: String? = nil, mimeType: String? = nil) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

    public let data: Data
    public let name: String
    public let fileName: String?
    public let mimeType: String?
}
