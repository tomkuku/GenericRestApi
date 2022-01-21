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

enum GoRestDeleteUserRequestError: Error {
    case invalidUserId
    case server
    case client
}

protocol GoRestApiClient {
    func getUsers(completion: @escaping (Result<[User], GoRestGetUsersRequestError>) -> Void)
    func addUser(_ user: User, completion: @escaping (Result<String, GoRestAddUserRequestError>) -> Void)
    func deleteUser(_ user: User, completion: @escaping (Result<Void, GoRestDeleteUserRequestError>) -> Void)
}

final class GoRestApiClientImpl: GoRestApiClient {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientImpl()) {
        self.httpClient = httpClient
    }
    
    func getUsers(completion: @escaping (Result<[User], GoRestGetUsersRequestError>) -> Void) {
        DispatchQueue.global().async {
            let url = URL(string: "https://gorest.co.in/public/v1/users")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
                "Content-Type": "application/json"]
            
            self.httpClient.request(request) { result in
                if case .success(let response) = result {
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
                } else {
                    print("Error")
                    
                }
            }
        }
    }
    
    func addUser(_ user: User, completion: @escaping (Result<String, GoRestAddUserRequestError>) -> Void) {
        DispatchQueue.global().async {
            let userData = JSONCoder.encode(object: user)
            
            print(String(data: userData!, encoding: .utf8) ?? "No User")
            
            let url = URL(string: "https://gorest.co.in/public/v1/users")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = userData
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(Config.apiKey)"
            ]
                
            self.httpClient.request(request) { result in
                if case .success(let response) = result {
                    switch response.statusCode! {
                    case 201:
                        let locationURL = response.headers["Location"] as! String
                        completion(.success(locationURL))
                        
                    case 422:
                        // call parsing here...
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
    
    func deleteUser(_ user: User, completion: @escaping (Result<Void, GoRestDeleteUserRequestError>) -> Void) {
        DispatchQueue.global().async {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "gorest.co.in"
            urlComponents.path = "/public/v1/users/\(user.id!)"
            
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = "DELETE"
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
                "Content-Type": "application/json",
                "Authorization": "Bearer \(Config.apiKey)"
            ]
                
            self.httpClient.request(request) { result in
                if case .success(let response) = result {
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
        }
    }
}
