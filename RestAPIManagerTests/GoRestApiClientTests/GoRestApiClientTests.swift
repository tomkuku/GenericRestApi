//
//  GoRestAPIClient.swift
//  RestAPIManagerTests
//
//  Created by Tomasz Kukułka on 19/01/2022.
//

import XCTest

@testable import RestAPIManager

class GoRestAPIClientTests: XCTestCase {
    
    private var mock: HTTPClient!
    private var sut: GoRestAPIClient!
    
    override func setUp() {
        super.setUp()
        
        mock = GoRestApiHTTPClientMock()
        sut = GoRestAPIClient(httpClient: mock)
    }
    
    func test_getUsers() {
        let expectation = expectation(description: "get.users")
        
        let getUseresCall = GetUsersGoRestAPICall()
        var result: GetUsersGoRestAPICall.ResultType!
        var isMainThread: Bool!
        
        sut.call(getUseresCall) {
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
        
        let user = User(id: 324, name: "Steve", email: "Jobs", gender: .male, state: .active)
        
        let addUserCall = AddUserGoRestAPICall(user)
        var result: AddUserGoRestAPICall.ResultType!
        var isMainThread: Bool!
        
        sut.call(addUserCall) {
            result = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
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
        
        let user = User(id: 324, name: "Steve", email: "Jobs", gender: .male, state: .inactive)
        
        let deleteUserCall = UpdateUserGoRestAPICall(user)
        var result: UpdateUserGoRestAPICall.ResultType!
        var isMainThread: Bool!
        
        sut.call(deleteUserCall) {
            result = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertFalse(isMainThread)
        
        switch result {
        case .success(): break
        case .failure(_), .none:
            XCTFail()
        }
    }

    func tests_deleteUser() {
        let expectation = expectation(description: "delete.user")
        
        let user = User(id: 324, name: "Steve", email: "Jobs", gender: .male, state: .inactive)
        
        let deleteUserCall = DeleteUserGoRestAPICall(user)
        var result: DeleteUserGoRestAPICall.ResultType!
        var isMainThread: Bool!
        
        sut.call(deleteUserCall) {
            result = $0
            isMainThread = Thread.current.isMainThread
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertFalse(isMainThread)
        
        switch result {
        case .success(): break
        case .failure(_), .none:
            XCTFail()
        }
    }
}
