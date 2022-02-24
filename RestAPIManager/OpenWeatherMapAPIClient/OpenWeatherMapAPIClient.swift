//
//  OpenWeatherMapRestAPIClient.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 23/01/2022.
//

import Foundation

final class OpenWeatherMapRestAPIClient: RestAPIClient {
    
    typealias Endpoint = CallEndpoint
    
    enum CallEndpoint: HTTPEndpint {
        case getCurrentWeather(Int)
        case getCurrentAirPollution(lat: Double, lon: Double)
        
        var url: URL {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "api.openweathermap.org"
            
                    
            switch self {
            case .getCurrentWeather(let cityId):
                urlComponents.path = "/data/2.5/weather"
                urlComponents.queryItems = [
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "id", value: "\(cityId)")]
                
            case .getCurrentAirPollution(let lat, let lon):
                urlComponents.path = "/data/2.5/air_pollution"
                urlComponents.queryItems = [
                    URLQueryItem(name: "lat", value: "\(lat)"),
                    URLQueryItem(name: "lon", value: "\(lon)")]
            }
            
            urlComponents.queryItems?.append(URLQueryItem(name: "appid", value: Config.openWeatherMapAPIKey))
            
            return urlComponents.url!
        }
        
        var headers: [String : String] {
            return [:]
        }
    }
    
    var httpClient: HTTPClient
    
    init(httpClient: HTTPClient = HTTPClientImpl()) {
        self.httpClient = httpClient
    }
}
