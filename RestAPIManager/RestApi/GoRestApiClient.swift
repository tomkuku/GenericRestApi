//
//  GoRestApiClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

protocol GoRestApiClient {
    func call<R: HTTPRequest>(request: R, completion: @escaping (R.ResultType) -> Void)
}

final class GoRestApiClientImpl: GoRestApiClient {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientImpl()) {
        self.httpClient = httpClient
    }
    
    func call<R: HTTPRequest>(request: R, completion: @escaping (R.ResultType) -> Void) {
        DispatchQueue.global().async {
            self.httpClient.request(request) { result in
                switch result {
                case .success(let response):
                    request.handleResponse(response, completion: completion)
                    
                case .failure(let httpClientError):
                    completion(.failure(.init(httpClient: httpClientError)))
                    
                }
            }
        }
    }
}
