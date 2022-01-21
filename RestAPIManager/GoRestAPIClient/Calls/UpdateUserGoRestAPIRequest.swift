//
//  UpdateUserGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct UpdateUserGoRestApiRequest: RestAPICall {
    
    typealias Client = GoRestAPIClient
    typealias ResultSuccess = Void
    typealias ResultFailure = FailureError
    
    enum FailureError: ResultFailureError {
        case invalidUserId
        case emailTaken
        case nameTaken
        case server
        case client
        case other
        case httpClient(HTTPClientError)
        
        init(httpClient: HTTPClientError) {
            self = .httpClient(httpClient)
        }
    }
    
    var url: URL
    var method: HTTPMethod! = .patch
    var body: Data?
    var headers: [String : String] = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer \(Config.apiKey)"]
    
    init(_ user: User) {
        self.url = URL(string: "https://gorest.co.in/public/v1/users/\(String(describing: user.id))")!
        self.body = JSONCoder.encode(object: user)
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
            
        case 400...499:
            completion(.failure(.client))
            
        case 500...599:
            completion(.failure(.server))
            
        default: break
        }
    }
}
