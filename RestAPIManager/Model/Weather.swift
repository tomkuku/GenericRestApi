//
//  Weather.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 22/01/2022.
//

import Foundation

struct Weather {
    var temp: Double?
    var pressure: Int?
    var humidity: Int?
    var tempMin: Double?
    var tempMax: Double?
    var windSeed: Float?
    var cloudsAll: Int?
}

extension Weather: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case main
        case temp
        case pressure
        case humidity
        case tempMin   = "temp_min"
        case tempMax   = "temp_max"
        
        case wind
        case windSpeed = "speed"
        
        case clouds
        case cloudsAll = "all"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let main = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .main)
        self.temp = try main.decode(Double.self, forKey: .temp)
        self.pressure = try main.decode(Int.self, forKey: .pressure)
        self.humidity = try main.decode(Int.self, forKey: .humidity)
        self.tempMin = try main.decode(Double.self, forKey: .tempMin)
        self.tempMax = try main.decode(Double.self, forKey: .tempMax)
        
        let wind = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .wind)
        self.windSeed = try wind.decode(Float.self, forKey: .windSpeed)
        
        let clouds = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .clouds)
        self.cloudsAll = try clouds.decode(Int.self, forKey: .cloudsAll)
    }
}
