//
//  RestAPIClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 22/01/2022.
//

import Foundation

protocol HTTPEndpint {
    var url: URL { get }
    var headers: [String: String] { get }
}

protocol RestAPIClient {
    associatedtype Endpoint: HTTPEndpint
    associatedtype FailureError: RestAPICallFailureResultError
    var httpClient: HTTPClient { get }
    func call<C: RestAPICall>(_ call: C, completion: @escaping (C.ResultType) -> Void) where C.Client == Self
}

extension RestAPIClient {
    
    func call<C: RestAPICall>(_ call: C, completion: @escaping (C.ResultType) -> Void) where C.Client == Self {
        DispatchQueue.global().async {
            let httpRequest = HTTPRequest(method: call.httpRequest.method,
                                          url: call.httpRequest.url,
                                          headers: call.httpRequest.headers,
                                          body: call.httpRequest.body)
            
            self.httpClient.request(httpRequest) { result in
                switch result {
                case .success(let response):
                    call.handleResponse(response, completion: completion)
                    
                case .failure(let httpClientError): break
//                    completion(.failure(.init(httpClient: httpClientError)))
                    
                }
            }
        }
    }
}
