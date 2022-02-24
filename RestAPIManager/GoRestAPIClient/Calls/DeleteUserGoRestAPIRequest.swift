//
//  DeleteUserGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct DeleteUserGoRestAPICall: RestAPICall {
    
    typealias SuccessResult = Void
    typealias FailureResult = FailureError
    typealias Client = GoRestAPIClient
    
    enum FailureError: RestAPICallFailureResultError {
        case invalidUserId
        case unhandled(HTTPError)
    }
    
    var httpRequest: HTTPRequest
    var endpoint: GoRestAPIClient.CallEndpoint
    
    init(_ user: User) {
        endpoint = .deleteUser(user)
        httpRequest = .init(method: .delete,
                            url: endpoint.url,
                            headers: endpoint.headers,
                            body: nil)
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode! {
        case 204:
            completion(.success(()))
            
        case 404:
            completion(.failure(.invalidUserId))
            
        default:
            completion(.failure(.unhandled(.init(statusCode: response.statusCode))))
        }
    }
}
