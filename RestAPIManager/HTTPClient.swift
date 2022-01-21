//
//  HTTPClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum HTTPClientError: Error {
    case `internal`
    case noInternatConnection
}

struct HTTPRequest {
    var method: HTTPMethod
    var url: URL
    var headers: [String: String]?
    var body: Data?
}

struct HTTPResponse {
    var statusCode: Int!
    var headers: [AnyHashable: Any] = [:]
    var body: Data?
}

protocol HTTPClient {
    func request(_ request: HTTPRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void)
}

final class HTTPClientImpl: HTTPClient {
    
    // MARK: Properties
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: configuration)
    }
    
    func request(_ request: HTTPRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
        
        self.session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.internal))
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                completion(.failure(.internal))
                return
            }
            
            let httpResponse = HTTPResponse(statusCode: httpUrlResponse.statusCode,
                                            headers: httpUrlResponse.allHeaderFields,
                                            body: data)
            
            completion(.success(httpResponse))
        }.resume()
    }
}
