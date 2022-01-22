//
//  RestAPIClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 22/01/2022.
//

import Foundation

protocol RestAPIClient {
    func call<C: RestAPICall>(_ call: C, completion: @escaping (C.ResultType) -> Void)
}
