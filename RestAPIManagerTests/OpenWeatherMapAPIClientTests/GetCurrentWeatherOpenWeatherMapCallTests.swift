//
//  GetCurrentWeatherOpenWeatherMapCallTests.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 24/02/2022.
//

import Foundation
import XCTest
import Hamcrest

@testable import RestAPIManager

final class OpenWeatherMapHTTPClientMock: HTTPClient {
    func request(_ request: HTTPRequest, completion: @escaping (Result<HTTPResponse, HTTPClientError>) -> Void) {
        var response = HTTPResponse()
        let httpComponenets = URLComponents(string: request.url.absoluteString)!
        
        if httpComponenets.queryItems!.contains(URLQueryItem(name: "id", value: "3085041")) {
            response.body = Data(jsonFileName: "OpenWeatherMapCurrentWeatherTestData")
            response.statusCode = 200
        } else if httpComponenets.queryItems!.contains(URLQueryItem(name: "id", value: "0")) {
            response.body = nil
            response.statusCode = 404
        }
        
        completion(.success(response))
        return
    }
}

final class GetCurrentWeatherOpenWeatherMapCallTests: XCTestCase {
    
    private var mock: OpenWeatherMapHTTPClientMock!
    private var apiClient: OpenWeatherMapRestAPIClient!
    
    override func setUp() {
        super.setUp()
        
        mock = OpenWeatherMapHTTPClientMock()
        apiClient = OpenWeatherMapRestAPIClient(httpClient: mock)
    }
    
    func test_failed_getCurrentWeather() {
        let expectation = expectation(description: "get.current.weather.failed")
        
        let getUseresCall = GetCurrentWeatherOpenWeatherMapCall(cityId: 0)
        var result: GetCurrentWeatherOpenWeatherMapCall.ResultType!
        
        apiClient.call(getUseresCall) {
            result = $0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        switch result {
        case .failure(let failureResult):
            assertThat(failureResult, equalTo(.invalidCityId))
        
        default:
            XCTFail()
        }
    }
    
    func test_succeeded_getCurrentWeather() {
        let expectation = expectation(description: "get.current.weather.succeeded")
        let expectedWeather = Weather(temp: 281.03,
                                      pressure: 1021,
                                      humidity: 51,
                                      tempMin: 278.85,
                                      tempMax: 282.59,
                                      windSeed: 1.54,
                                      cloudsAll: 0)
        
        let getUseresCall = GetCurrentWeatherOpenWeatherMapCall(cityId: 3085041)
        var result: GetCurrentWeatherOpenWeatherMapCall.ResultType!
        
        apiClient.call(getUseresCall) {
            result = $0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        switch result {
        case .success(let weather):
            assertThat(weather, equalTo(expectedWeather))
            
        default:
            XCTFail()
        }
    }
}
