//
//  URLQueryItem+subscript.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 24/02/2022.
//

import Foundation

extension Array where Element == URLQueryItem {
    subscript(name: String) -> String? {
        for queryItem in self {
            if queryItem.name == name {
                return queryItem.value!
            }
        }
        return nil
    }
}
