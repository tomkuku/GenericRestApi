//
//  RestAPICall.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

protocol ResultFailureError: Error {
    init(httpClient: HTTPClientError)
}

protocol RestAPICall {
    associatedtype Client: RestAPIClient
    associatedtype ResultSuccess
    associatedtype ResultFailure: ResultFailureError
    
    typealias ResultType = Result<ResultSuccess, ResultFailure>
    
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void)
}
