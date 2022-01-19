//
//  User.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

struct User {
    
    enum Gender: String, Decodable {
        case male
        case female
    }
    
    enum State: String, Decodable {
        case active
        case inactive
    }
    
    var id: Int?
    var name: String?
    var email: String?
    var gender: Gender?
    var state: State?
}


extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case gender
        case state = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.gender = try container.decode(Gender.self, forKey: .gender)
        self.state = try container.decode(State.self, forKey: .state)
    }
}
