//
//  URLSessionTest.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 05/09/22.
//

import XCTest
@testable import TawkAssignment

class URLSessionTest: XCTestCase {

    let invalidURL:String = ""
    let validURL:String = "http://www.asmtechnology.com/apress2017/albumlist.json"
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetUserResponseSuccessfully() {
        let expectation = self.expectation(description: "Expected Success block to be called")
        let client = ApiClient()
        client.session = MockURLSessionWithData()
        client.dataTask = MockURLSessionDataTaskWithData()
        let url = URL(string: validURL)!
        let resource:Resource<UserModel> = Resource(url: url, httpMethod: .get, body: nil)
        client.fetch(resource: resource){result in
            switch result{
            case .success(let data):
                print(data)
                expectation.fulfill()
            case .failure(let error):
                print(error)
            } }

        self.waitForExpectations(timeout: 20.0, handler: nil)
    }
    

    func testURLSessionShouldThrowError() {
        let expectation = self.expectation(description: "Expected failure block to be called")
        let client = ApiClient()
        client.session = MockURLSession()
        client.dataTask = MockURLSessionDataTask()
        let url = URL(string: validURL)!
        let resource:Resource<UserModel> = Resource(url: url, httpMethod: .get, body: nil)
        client.fetch(resource: resource){result in
            switch result{
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
                expectation.fulfill()
            } }

        self.waitForExpectations(timeout: 20.0, handler: nil)
    }

    
}

