//
//  AddUserGoRestAPIRequest.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

struct AddUserGoRestApiRequest: RestAPICall {
    
    typealias Client = GoRestAPIClient
    typealias ResultSuccess = URL
    typealias ResultFailure = FailureError
    
    enum FailureError: ResultFailureError {
        case nameTaken
        case emailTaken
        case server
        case client
        case other
        case httpClient(HTTPClientError)
        
        init(httpClient: HTTPClientError) {
            self = .httpClient(httpClient)
        }
    }
    
    var url: URL
    var method: HTTPMethod! = .post
    var body: Data?
    var headers: [String : String] = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer \(Config.apiKey)"]
    
    init(_ user: User) {
        self.body = JSONCoder.encode(object: user)
        self.url = Client.Call.addUser.url
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode! {
        case 201:
            if let location = response.headers["Location"] as? String {
                completion(.success(URL(string: location)!))
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
