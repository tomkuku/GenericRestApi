//
//  AirPollution.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 22/01/2022.
//

import Foundation

struct AirPollution {
    let aqi: Int?
    let co: Float?
    let no: Float?
    let no2: Float?
    let o3: Float?
    let so2: Float?
    let pm25: Float?
    let pm10: Float?
    let nh3: Float?
}

extension AirPollution: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case main
        case aqi
        
        case components
        case co
        case no
        case no2
        case o3
        case so2
        case pm25 = "pm2_5"
        case pm10 = "pm10"
        case nh3
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        self.aqi = try main.decode(Int.self, forKey: .aqi)
        
        let components = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .components)
        self.co = try components.decode(Float.self, forKey: .co)
        self.no = try components.decode(Float.self, forKey: .no)
        self.no2 = try components.decode(Float.self, forKey: .no2)
        self.o3 = try components.decode(Float.self, forKey: .o3)
        self.so2 = try components.decode(Float.self, forKey: .so2)
        self.pm25 = try components.decode(Float.self, forKey: .pm25)
        self.pm10 = try components.decode(Float.self, forKey: .pm10)
        self.nh3 = try components.decode(Float.self, forKey: .nh3)
    }
}
