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
        
        let getUseresRequest = GetUsersGoRestApiRequest()
        var result: Result<GetUsersGoRestApiRequest.ResultSuccess, GetUsersGoRestApiRequest.ResultFailure>!
        var isMainThread: Bool!
        
        sut.call(request: getUseresRequest) {
            result = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertFalse(isMainThread)
        
        switch result {
        case .success(let users):
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(users.first?.id, 59)
            XCTAssertEqual(users.first?.name, "John Smith")
            XCTAssertEqual(users.first?.email, "john.smith@gmail.com")
            XCTAssertEqual(users.first?.gender, .male)
            XCTAssertEqual(users.first?.state, .active)
        case .failure(_), .none:
            XCTFail()
        }
    }
    
    func tests_addUser() {
        let expectation = expectation(description: "add.user")
        
        let user = User(id: 324, name: "Steve", email: "Jobs", gender: .male, state: .inactive)
        
        let addUserRequest = AddUserGoRestApiRequest(user)
        var result: Result<AddUserGoRestApiRequest.ResultSuccess, AddUserGoRestApiRequest.ResultFailure>!
        var isMainThread: Bool!
        
        sut.call(request: addUserRequest) {
            result = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)
        
        XCTAssertFalse(isMainThread)
        
        switch result {
        case .success(let url):
            XCTAssertEqual(url, URL(string: "https://gorest.co.in/public/v1/users/3656")!)
        case .failure(_), .none:
            XCTFail()
        }
    }
    
    func tests_updateUser() {
        let expectation = expectation(description: "update.user")
        var isMainThread: Bool!
        var result: Result<Void, GoRestUpdateUserRequestError>!

        let user = User(id: 672,
                        name: "Bill",
                        email: "Gates",
                        gender: .male,
                        state: .inactive)

        sut.updateUser(user) {
            result = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }

        waitForExpectations(timeout: 4, handler: nil)

        XCTAssertFalse(isMainThread)

        switch result {
        case .success(): break
        case .failure(_), .none:
            XCTFail()
        }
    }

    func tests_deleteUser() {
        let expectation = expectation(description: "delete.user")
        var isMainThread: Bool!
        var result: Result<Void, GoRestDeleteUserRequestError>!

        let user = User(id: 672,
                        name: "Bill",
                        email: "Gates",
                        gender: .male,
                        state: .inactive)

        sut.deleteUser(user) {
            result = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }

        waitForExpectations(timeout: 4, handler: nil)

        XCTAssertFalse(isMainThread)

        switch result {
        case .success(): break
        case .failure(_), .none:
            XCTFail()
        }
    }
}
