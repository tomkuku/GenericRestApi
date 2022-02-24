//
//  GoRestAPIClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

final class GoRestAPIClient: RestAPIClient {
    
    typealias Endpoint = CallEndpoint
    
    enum CallEndpoint: HTTPEndpint {
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
        
        var headers: [String: String] {
            var headersElements: [String: String] = [
                "Accept": "application/json",
                "Content-Type": "application/json"]
            
            switch self {
            case .getUsers:
                headersElements["Authorization"] = "Bearer \(Config.goRestAPIKey)"
                
            default: break
            }
            return headersElements
        }
    }
    
    var httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientImpl()) {
        self.httpClient = httpClient
    }
}
