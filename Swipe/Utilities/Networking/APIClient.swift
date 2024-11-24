//
//  APIClient.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

final class APIClient {
    
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private static let session: URLSession = {
       let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private static let successRange: Range = 200..<300
    
    
    static func sendRequest<T:Decodable>(endPoint: EndPoint) async throws -> T {
        let (data, response) = try await session.data(for: endPoint.asUrlRequest())
        let validData = try validateResponse(data: data, response: response)
        return try decoder.decode(T.self, from: validData)
    }
    
    private static func validateResponse(data: Data, response: URLResponse) throws -> Data {
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.invalidResponse
        }
        if successRange.contains(code) {
            return data
        } else {
            switch code {
            case 401:
                throw NetworkError.unAuthorized
            case 404:
                throw NetworkError.notFound
            default:
                throw NetworkError.unExpectedError(code)
            }
        }
    }
}
