//
//  HTTPClientMock.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 19/01/2022.
//

import Foundation

@testable import RestAPIManager

final class HTTPClientMock: HTTPClient {
    
    func request(_ request: URLRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void) {
        var response = HTTPResponse()
        
        switch (request.url!.absoluteString, request.httpMethod) {
        case ("https://gorest.co.in/public/v1/users", HTTPMethod.get.rawValue):
            response.body = getData(fromFile: "UsersTestFile")
            response.statusCode = 200
            
        case ("https://gorest.co.in/public/v1/users", HTTPMethod.post.rawValue):
            response.headers["Location"] = "https://gorest.co.in/public/v1/users/3656"
            response.statusCode = 201
            
        case (_, HTTPMethod.delete.rawValue):
            response.statusCode = 204
        
        default:
            break
        }
        
        completion(.success(response))
        return
    }
    
    private func getData(fromFile file: String) -> Data {
        let url = Bundle.main.url(forResource: file, withExtension: "json")!
        var data: Data!
        
        do {
            data = try Data(contentsOf: url)
        } catch {
            fatalError()
        }
        return data
    }
}
