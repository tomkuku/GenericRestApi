//
//  GoRestApiClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

enum HTTPResponseError {
    case server
    case `internal`
    case client
}

protocol GoRestApiClient {
    func getUsers(completion: @escaping ([User]) -> Void)
}

final class GoRestApiClientImpl: GoRestApiClient {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientImpl()) {
        self.httpClient = httpClient
    }
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        DispatchQueue.global().async {
            let url = URL(string: "https://gorest.co.in/public/v1/users")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = [
                "Accept": "application/json",
                "Content-Type": "application/json"]
            
            self.httpClient.request(request) { result in
                switch result {
                case .success(let data):
                    let users: [User]? = JSONCoder.decodeToArray(from: data!, path: "data")
                    completion(users ?? [])
                    return
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
