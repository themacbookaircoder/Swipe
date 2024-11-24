//
//  TargetType.swift
//  Swipe
//
//  Created by Kuldeep on 23/11/24.
//

import Foundation

protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var params: RequestParams? { get }
}

extension TargetType {
    func asUrlRequest() throws -> URLRequest {
        let url = try baseURL.asUrl()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header

        switch params {
        case .query(let request):
            let params = try request.toDictionary()
            let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
            var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            urlRequest.url = components?.url
        case .body(let request):
            let params = try request.toDictionary()
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        case .formData(let request, let files):
            let bodyParameters = try request.toDictionary()
            urlRequest.addMultipartWithBody(bodyParameters: bodyParameters, multipart: files)
        default:
            break
        }

        urlRequest.logCURL(pretty: true)
        return urlRequest
    }
}

extension URLRequest {
    /// Creates data in formate of form data specification
    /// - Parameters:
    ///   - name: Name of field
    ///   - value: Value of field
    ///   - boundary: Data boundary of field
    /// - Returns: returns the formatted Data object
    func convertFormField(named name: String, value: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendString("\r\n")
        data.append(value)
        data.appendString("\r\n")
        return data as Data
    }
    
    /// Creates data in format of content desposition (mutipart file upload) specification
    /// - Parameters:
    ///   - fieldName: Name of field
    ///   - fileName: File name
    ///   - mimeType: File's mime type
    ///   - fileData: File's content
    ///   - boundary: Data boundary of field
    /// - Returns: returns the formatted data
    func convertFileData(fieldName: String,
                         fileName: String,
                         mimeType: String,
                         fileData: Data,
                         using boundary: String) -> Data {
      let data = NSMutableData()
      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")
      return data as Data
    }
    
    mutating func addMultipartWithBody(bodyParameters: [String: Any], multipart multipartArray: [MultipartFormData]) {
        let boundary = "Boundary-\(UUID().uuidString)"
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let httpBody = NSMutableData()
        
        // Add body parameters as form fields
        for (key, value) in bodyParameters {
            if let valueString = serializeValue(value) {
                httpBody.append(convertFormField(named: key, value: valueString.data(using: .utf8) ?? Data(), using: boundary))
            }
        }
        
        // Add multipart data (files[])
        for file in multipartArray {
            if let fileName = file.fileName, let mimeType = file.mimeType {
                httpBody.append(convertFileData(fieldName: file.name, fileName: fileName, mimeType: mimeType, fileData: file.data, using: boundary))
            }
        }
        
        // Close the boundary
        httpBody.appendString("--\(boundary)--\r\n")
        self.httpBody = httpBody as Data
    }


    private func serializeValue(_ value: Any) -> String? {
        switch value {
        case let string as String:
            return string
        case let number as NSNumber:
            return number.stringValue
        case let double as Double:
            return String(format: "%.2f", double)
        case let array as [Any]:
            return array.map { String(describing: $0) }.joined(separator: ",")
        default:
            return String(describing: value)
        }
    }
}

extension URLRequest {
    @discardableResult
    func logCURL(pretty: Bool = false) -> String {
        print("============= cURL ============= \n")
        
        let newLine = pretty ? "\\\n" : ""
        let method = (pretty ? "--request " : "-X ") + "\(self.httpMethod ?? "GET") \(newLine)"
        let url: String = (pretty ? "--url " : "") + "\'\(self.url?.absoluteString ?? "")\' \(newLine)"
        
        var cURL = "curl "
        var header = ""
        var data: String = ""
        
        if let httpHeaders = self.allHTTPHeaderFields, httpHeaders.keys.count > 0 {
            for (key, value) in httpHeaders {
                header += (pretty ? "--header " : "-H ") + "\'\(key): \(value)\' \(newLine)"
            }
        }
        
        if let bodyData = self.httpBody, let bodyString = String(data: bodyData, encoding: .utf8), !bodyString.isEmpty {
            data = "--data '\(bodyString)'"
        }
        
        cURL += method + url + header + data
        print(cURL)
        return cURL
    }
}
