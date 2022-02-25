//
//  RestAPICall.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 21/01/2022.
//

import Foundation

protocol RestAPICallFailureResultError: Error, Equatable {
    static func unhandled(_ httpError: HTTPError) -> Self
}

protocol RestAPICall {
    associatedtype SuccessResult
    associatedtype Client: RestAPIClient
    
    typealias ResultType = Result<SuccessResult, Client.FailureError>
    
    var httpRequest: HTTPRequest { get }
    var endpoint: Client.Endpoint { get }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void)
}

