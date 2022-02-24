//
//  GetCurrentAirPollutionOpenWeatherMapAPICall.swift
//  RestAPIManager
//
//  Created by Tomasz Kukułka on 24/01/2022.
//

import Foundation

struct GetCurrentAirPollutionOpenWeatherMapAPICall: RestAPICall {
        
    typealias SuccessResult = AirPollution
    typealias FailureResult = FailureError
    typealias Client = OpenWeatherMapRestAPIClient
    
    enum FailureError: RestAPICallFailureResultError {
        case noData
        case noCoordinates
        case wrongLatitude
        case wrongLongitude
        case unhandled(HTTPError)
    }
    
    var httpRequest: HTTPRequest
    var endpoint: OpenWeatherMapRestAPIClient.CallEndpoint
    
    init(lat: Double, lon: Double) {
        endpoint = .getCurrentAirPollution(lat: lat, lon: lon)
        httpRequest = .init(method: .get,
                            url: endpoint.url,
                            headers: endpoint.headers,
                            body: nil)
    }
    
    func handleResponse(_ response: HTTPResponse, completion: (ResultType) -> Void) {
        switch response.statusCode {
        case 200:
            if let data = response.body,
               let airPollutions: [AirPollution] = JSONCoder.decode(from: data, path: "list"),
               let firstAirPollution = airPollutions.first {
                completion(.success(firstAirPollution))
                
            } else {
                completion(.failure(.noData))
            }
            
        case 400:
            // parsing
            completion(.failure(.wrongLatitude))
            
        default:
            completion(.failure(.unhandled(.init(statusCode: response.statusCode))))
        }
    }
}
