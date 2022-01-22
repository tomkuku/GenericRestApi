//
//  GoRestAPIClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

final class GoRestAPIClient: RestAPIClient {
    
    enum Call {
        case getUsers
        case addUser
        case updateUser(User)
        case deleteUser(User)
        
        var url: URL {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "gorest.co.in"
            
            switch self {
            case .getUsers, .addUser:
                urlComponents.path = "/public/v1/users"
                
            case .updateUser(let user), .deleteUser(let user):
                urlComponents.path = "/public/v1/users/\(user.id!)"
            }
            
            return urlComponents.url!
        }
    }
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientImpl()) {
        self.httpClient = httpClient
    }
    
    func call<C: RestAPICall>(_ call: C, completion: @escaping (C.ResultType) -> Void) {
        DispatchQueue.global().async {
            let httpRequest = HTTPRequest(method: call.method,
                                          url: call.url,
                                          headers: call.headers,
                                          body: call.body)
            
            self.httpClient.request(httpRequest) { result in
                switch result {
                case .success(let response):
                    call.handleResponse(response, completion: completion)
                    
                case .failure(let httpClientError):
                    completion(.failure(.init(httpClient: httpClientError)))
                    
                }
            }
        }
    }
}
