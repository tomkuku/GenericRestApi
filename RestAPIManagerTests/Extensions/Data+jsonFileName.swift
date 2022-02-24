//
//  Data+jsonFileName.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 24/02/2022.
//

import Foundation

extension Data {
    init(jsonFileName: String) {
        let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json")!
        
        do {
            self = try Data(contentsOf: url)
        } catch {
            fatalError()
        }
    }
}
