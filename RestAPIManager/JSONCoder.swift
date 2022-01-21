//
//  JSONCoder.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 19/01/2022.
//

import Foundation

final class JSONCoder {
    
    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()
    
    private init () {}
    
    static func decode<T: Decodable>(from data: Data, path: String?) -> T? {
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
    
    static func encode<T: Encodable>(object: T) -> Data? {
        var data: Data? = nil
        
        do {
            data = try encoder.encode(object)
        } catch {
            print(error.localizedDescription)
        }
        
        return data
    }
}
