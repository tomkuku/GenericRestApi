//
//  HTTPClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

enum HTTPClientError: Error {
    case `internal`
    case client
    case server
}

protocol HTTPClient {
    func request(_ request: URLRequest, completion: @escaping (Result<Data?, HTTPClientError>) -> Void)
}

final class HTTPClientImpl: HTTPClient {
    
    // MARK: Properties
    
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: configuration)
    }
    
    func request(_ request: URLRequest, completion: @escaping (Result<Data?, HTTPClientError>) -> Void) {
        self.session.dataTask(with: request) { data, response, error in
            print("[THERAD]: HTTPClientImpl is main \(#line)", Thread.current.isMainThread)
            if error != nil {
                completion(.failure(.internal))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.internal))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                completion(.success(data))
                return
            case 200...299:
                completion(.failure(.internal))
                return
            case 400...499:
                completion(.failure(.client))
                return
            case 500...599:
                completion(.failure(.server))
                return
            default:
                completion(.failure(.internal))
                return
            }
        }.resume()
    }
}
