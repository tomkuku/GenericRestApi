//
//  GetCurrentWeatherOpenWeatherMapCall.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 23/01/2022.
//

import Foundation

struct GetCurrentWeatherOpenWeatherMapCall: RestAPICall {
    
    typealias SuccessResult = Weather
    typealias FailureResult = FailureError
    typealias Client = OpenWeatherMapRestAPIClient
    
    enum FailureError: RestAPICallFailureResultError {
        case noData
        case invalidCityId
        case unhandled(HTTPError)
    }
    
    var httpRequest: HTTPRequest
    var endpoint: OpenWeatherMapRestAPIClient.CallEndpoint
    
    init(cityId: Int) {
        endpoint = .getCurrentWeather(cityId)
        httpRequest = .init(method: .get,
                            url: endpoint.url,
                            headers: endpoint.headers,
                            body: nil)
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode {
        case 200:            
            if let data = response.body, let weather: Weather = JSONCoder.decode(from: data, path: nil) {
                completion(.success(weather))
            } else {
                completion(.failure(.noData))
            }
            
        case 404:
            // parsing
            completion(.failure(.invalidCityId))
            
        default:
            completion(.failure(.unhandled(.init(statusCode: response.statusCode))))
        }
    }
}
