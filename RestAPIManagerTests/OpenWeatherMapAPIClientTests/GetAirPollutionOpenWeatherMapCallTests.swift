//
//  GetAirPollutionOpenWeatherMapCallTests.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 24/02/2022.
//

import XCTest
import Hamcrest

@testable import RestAPIManager

extension Array where Element == URLQueryItem {
    subscript(name: String) -> String {
        for queryItem in self {
            if queryItem.name == name {
                return queryItem.value!
            }
        }
        
        return ""
    }
}

private final class HTTPClientMock: HTTPClient {
    func request(_ request: HTTPRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void) {
        var response = HTTPResponse()
        let httpComponenets = URLComponents(string: request.url.absoluteString)!
        
        let lon = httpComponenets.queryItems!["lon"]
        let lat = httpComponenets.queryItems!["lat"]
        
        if lon == "19.9431" && lat == "50.0483" {
            response.body = Data(jsonFileName: "OpenWeatherMapGetAirPollutionTestData")
            response.statusCode = 200
        } else {
            response.statusCode = 400
        }
        
        completion(.success(response))
        return
    }
}

final class GetAirPollutionOpenWeatherMapCallTests: XCTestCase {
    
    private var mock: HTTPClient!
    private var apiClient: OpenWeatherMapRestAPIClient!
    
    override func setUp() {
        super.setUp()
        
        mock = HTTPClientMock()
        apiClient = OpenWeatherMapRestAPIClient(httpClient: mock)
    }
    
    func test_failed_getAirPollution() {
        let expectation = expectation(description: "get.air.pollution.failed")
        
        let getUseresCall = GetAirPollutionOpenWeatherMapAPICall(lat: 0, lon: 0)
        var result: GetAirPollutionOpenWeatherMapAPICall.ResultType!
        
        apiClient.call(getUseresCall) {
            result = $0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        switch result {
        case .failure(let failureResult):
            assertThat(failureResult, equalTo(.wrongLocation))
        
        default:
            XCTFail()
        }
    }
    
    func test_succeeded_getAirPollution() {
        let expectation = expectation(description: "get.air.pollution.succeeded")
        
        let expectedAirPollution = AirPollution(aqi: 2,
                                           co: 447.27,
                                           no: 4.97,
                                           no2: 17.14,
                                           o3: 70.81,
                                           so2: 20.74,
                                           pm25: 11.78,
                                           pm10: 15.09,
                                           nh3: 4.94)
        
        let getUseresCall = GetAirPollutionOpenWeatherMapAPICall(lat: 50.0483, lon: 19.9431)
        var result: GetAirPollutionOpenWeatherMapAPICall.ResultType!
        
        apiClient.call(getUseresCall) {
            result = $0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        switch result {
        case .success(let airPollution):
            assertThat(airPollution, equalTo(expectedAirPollution))
            
        default:
            XCTFail()
        }
    }
}

