//
//  User.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 18/01/2022.
//

import Foundation

struct User: Decodable, Encodable {
    
    enum Gender: String, Codable {
        case male
        case female
    }
    
    enum State: String, Codable {
        case active
        case inactive
    }
    
    var id: Int?
    var name: String?
    var email: String?
    var gender: Gender?
    var state: State?
}


extension User {
    
    private enum CodingKeys: String, CodingKey {
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(state, forKey: .state)
    }
}
