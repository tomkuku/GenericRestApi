//
//  AddUserGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct AddUserGoRestAPICall: RestAPICall {
    
    typealias SuccessResult = URL
    typealias FailureResult = FailureError
    typealias Client = GoRestAPIClient
    
    enum FailureError: RestAPICallFailureResultError {
        case nameTaken
        case emailTaken
        case noLocation
        case unhandled(HTTPError)
    }
    
    var httpRequest: HTTPRequest
    var endpoint: GoRestAPIClient.CallEndpoint = .addUser
    
    init(_ user: User) {
        httpRequest = .init(method: .post,
                            url: endpoint.url,
                            headers: endpoint.headers,
                            body: JSONCoder.encode(object: user))
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode! {
        case 201:
            if let location = response.headers["Location"] as? String {
                completion(.success(URL(string: location)!))
            } else {
                completion(.failure(.noLocation))
            }
        default:
            completion(.failure(.unhandled(.init(statusCode: response.statusCode))))
        }
    }
}
