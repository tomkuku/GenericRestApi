//
//  GetUsersGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct GetUsersGoRestAPICall: RestAPICall {
        
    typealias ResultSuccess = [User]
    typealias ResultFailure = FailureError
    typealias Client = GoRestAPIClient
    
    enum FailureError: ResultFailureError {
        case server
        case client
        case other
        case htppClient(HTTPClientError)
        
        init(httpClient: HTTPClientError) {
            self = .htppClient(httpClient)
        }
    }
    
    var url: URL
    var method: HTTPMethod = .get
    var body: Data? = nil
    var headers: [String : String] = [
        "Accept": "application/json",
        "Content-Type": "application/json"]
    
    init() {
        self.url = GoRestAPIClient.Call.getUsers.url
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode! {
        case 200:
            if let responseBody = response.body {
                let users: [User]? = JSONCoder.decode(from: responseBody, path: "data")
                completion(.success(users ?? []))
            } else {
                completion(.failure(.other))
            }
            
        case 400...499:
            completion(.failure(.client))
            
        case 500...599:
            completion(.failure(.server))
            
        default: break
        }
    }
}
