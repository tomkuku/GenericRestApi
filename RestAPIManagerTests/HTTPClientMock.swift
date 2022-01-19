//
//  HTTPClientMock.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 19/01/2022.
//

import Foundation

@testable import RestAPIManager

final class HTTPClientMock: HTTPClient {
    
    func request(_ request: URLRequest, completion: @escaping (Result<Data?, HTTPClientError>) -> Void) {
        if request.url!.absoluteString ==  "https://gorest.co.in/public/v1/users" {
            let data = getData(fromFile: "UsersTestFile")
            completion(.success(data))
            return
        }
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
