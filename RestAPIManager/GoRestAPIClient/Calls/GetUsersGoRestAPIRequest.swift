//
//  GetUsersGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct GetUsersGoRestAPICall: RestAPICall {
    
    typealias SuccessResult = [User]
    typealias FailureResult = FailureError
    typealias Client = GoRestAPIClient
    
    enum FailureError: RestAPICallFailureResultError {
        case noData
        case unhandled(HTTPError)
    }
    
    var httpRequest: HTTPRequest
    var endpoint: GoRestAPIClient.CallEndpoint = .getUsers
    
    init() {
        httpRequest = HTTPRequest(method: .get,
                                  url: endpoint.url,
                                  headers: endpoint.headers,
                                  body: nil)
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode {
        case 200:
            if let responseBody = response.body {
                let users: [User]? = JSONCoder.decode(from: responseBody, path: "data")
                completion(.success(users ?? []))
            } else {
                completion(.failure(.noData))
            }
        default:
            completion(.failure(.unhandled(.init(statusCode: response.statusCode))))
        }
    }
}
