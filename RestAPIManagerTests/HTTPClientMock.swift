//
//  HTTPClientMock.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 19/01/2022.
//

import Foundation

@testable import RestAPIManager

final class HTTPClientMock: HTTPClient {
    func request(_ request: HTTPRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void) {
        var response = HTTPResponse()
        
        switch (request.url.absoluteString, request.method) {
        case ("https://gorest.co.in/public/v1/users", .get):
            response.body = getData(fromFile: "UsersTestFile")
            response.statusCode = 200
            
        case ("https://gorest.co.in/public/v1/users", .post):
            response.headers["Location"] = "https://gorest.co.in/public/v1/users/3656"
            response.statusCode = 201
            
        case (_, .patch):
            response.statusCode = 200
            
        case (_, .delete):
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
