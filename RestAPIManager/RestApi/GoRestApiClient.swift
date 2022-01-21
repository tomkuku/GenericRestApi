//
//  GoRestApiClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

enum GoRestGetUsersRequestError: Error {
    case server
    case client
    case other
}

enum GoRestAddUserRequestError: Error {
    case nameTaken
    case emailTaken
    case server
    case client
}

enum GoRestUpdateUserRequestError: Error {
    case invalidUserId
    case nameTaken
    case emailTaken
    case server
    case client
}

enum GoRestDeleteUserRequestError: Error {
    case invalidUserId
    case server
    case client
}

protocol GoRestApiClient {
    func call<R: HTTPRequest>(request: R, completion: @escaping (R.ResultType) -> Void)
    
    func updateUser(_ user: User, completion: @escaping (Result<Void, GoRestUpdateUserRequestError>) -> Void)
}

final class GoRestApiClientImpl: GoRestApiClient {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientImpl()) {
        self.httpClient = httpClient
    }
    
    func updateUser(_ user: User, completion: @escaping (Result<Void, GoRestUpdateUserRequestError>) -> Void) {
        DispatchQueue.global().async {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "gorest.co.in"
            urlComponents.path = "/public/v1/users/\(user.id!)"
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = HTTPMethod.patch.rawValue
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(Config.apiKey)"
            ]
                
            self.httpClient.request(request) { result in
                if case .success(let response) = result {
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
        }
    }
    
    func call<R: HTTPRequest>(request: R, completion: @escaping (R.ResultType) -> Void) {
        DispatchQueue.global().async {
            self.httpClient.request(request) { result in
                switch result {
                case .success(let response):
                    request.handleResponse(response, completion: completion)
                    
                case .failure(let httpClientError):
                    completion(.failure(.init(httpClient: httpClientError)))
                    
                }
            }
        }
    }
}
