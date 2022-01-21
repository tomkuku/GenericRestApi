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
}

enum HTTPClientError: Error {
    case `internal`
    case noInternatConnection
}

struct HTTPResponse {
    var statusCode: Int!
    var headers: [AnyHashable: Any] = [:]
    var body: Data?
}

protocol HTTPClient {
    func request(_ request: URLRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void)
}

final class HTTPClientImpl: HTTPClient {
    
    // MARK: Properties
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: configuration)
    }
    
    func request(_ request: URLRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void) {
        self.session.dataTask(with: request) { data, response, error in
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
            return
        }.resume()
    }
}
