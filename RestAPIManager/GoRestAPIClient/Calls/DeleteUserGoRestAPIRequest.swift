//
//  DeleteUserGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct DeleteUserGoRestAPICall: RestAPICall {
    
    typealias Client = GoRestAPIClient
    typealias ResultSuccess = Void
    typealias ResultFailure = FailureError
    
    enum FailureError: ResultFailureError {
        case invalidUserId
        case server
        case client
        case other
        case httpClient(HTTPClientError)
        
        init(httpClient: HTTPClientError) {
            self = .httpClient(httpClient)
        }
    }
    
    var url: URL
    var method: HTTPMethod = .delete
    var body: Data?
    var headers: [String : String] = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer \(Config.apiKey)"]
    
    init(_ user: User) {
        self.url = GoRestAPIClient.Call.deleteUser(user).url
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode! {
        case 204:
            completion(.success(()))
            
        case 404:
            completion(.failure(.invalidUserId))
            
        case 400...499:
            completion(.failure(.client))
            
        case 500...599:
            completion(.failure(.server))
            
        default: break
        }
    }
}
