//
//  UpdateUserGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct UpdateUserGoRestAPICall: RestAPICall {
    
    typealias SuccessResult = Void
    typealias FailureResult = FailureError
    typealias Client = GoRestAPIClient
    
    enum FailureError: RestAPICallFailureResultError {
        case nameTaken
        case emailTaken
        case invalidUserId
        case unhandled(HTTPError)
    }
    
    var httpRequest: HTTPRequest
    var endpoint: GoRestAPIClient.CallEndpoint
    
    init(_ user: User) {
        endpoint = .updateUser(user)
        httpRequest = .init(method: .patch,
                            url: endpoint.url,
                            headers: endpoint.headers,
                            body: nil)
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode! {
        case 200:
            completion(.success(()))
            
        case 404:
            completion(.failure(.invalidUserId))
            
        case 422:
            // parsing here...
            completion(.failure(.emailTaken))
            
        default:
            completion(.failure(.unhandled(.init(statusCode: response.statusCode))))
        }
    }
}
