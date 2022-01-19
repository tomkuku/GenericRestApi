//
//  JSONCoder.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 19/01/2022.
//

import Foundation

final class JSONCoder {
    
    private static let decoder = JSONDecoder()
    
    private init () {}
    
    static func decodeToArray<T: Decodable>(from data: Data, path: String?) -> T? {
        var result: T? = nil
        
        do {
            var jsonData: Data!
            
            if let path = path {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                let dictAtPath = dictionary?[path] as? [NSDictionary]
                jsonData = try JSONSerialization.data(withJSONObject: dictAtPath ?? [], options: .withoutEscapingSlashes)
                
            } else {
                jsonData = data
            }
            
            result = try decoder.decode(T.self, from: jsonData)
        } catch {
            print(error.localizedDescription)
        }
        
        return result
    }
}
