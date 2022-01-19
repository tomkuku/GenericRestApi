//
//  GoRestApiClient.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 19/01/2022.
//

import XCTest

@testable import RestAPIManager

class GoRestAPIClient: XCTestCase {
    
    private var mock: HTTPClient!
    private var sut: GoRestApiClient!
    
    override func setUp() {
        super.setUp()
        
        mock = HTTPClientMock()
        sut = GoRestApiClientImpl(httpClient: mock)
    }
    
    func test_getUsers() {
        let expectation = expectation(description: "get.users")
        var users: [User] = []
        var isMainThread: Bool!
        
        sut.getUsers {
            users = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)
        
        XCTAssertFalse(isMainThread)
        XCTAssertEqual(users.count, 2)
        XCTAssertEqual(users.first?.id, 59)
        XCTAssertEqual(users.first?.name, "John Smith")
        XCTAssertEqual(users.first?.email, "john.smith@gmail.com")
        XCTAssertEqual(users.first?.gender, .male)
        XCTAssertEqual(users.first?.state, .active)
    }
}
