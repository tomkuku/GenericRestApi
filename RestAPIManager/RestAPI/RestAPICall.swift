//
//  RestAPICall.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

enum HTTPError: Error {
    case information
    case success
    case redirecton
    case server
    case client
    case unknown

    init(statusCode: Int) {
        switch statusCode {
        case 100...199:
            self = .information
        case 200...299:
            self = .success
        case 300...399:
            self = .redirecton
        case 400...499:
            self = .client
        case 500...599:
            self = .server
        default:
            self = .unknown
        }
    }
}

protocol RestAPICallFailureResultError: Error {
    static func unhandled(_ httpError: HTTPError) -> Self
}

protocol RestAPICall {
    associatedtype SuccessResult
    associatedtype FailureResult: RestAPICallFailureResultError
    associatedtype Client: RestAPIClient
    
    typealias ResultType = Result<SuccessResult, FailureResult>
    
    var httpRequest: HTTPRequest { get }
    var endpoint: Client.Endpoint { get }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void)
}

