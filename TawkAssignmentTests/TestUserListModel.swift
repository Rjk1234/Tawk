//
//  TestUserListModel.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 07/09/22.
//

import XCTest
@testable import TawkAssignment

class TestUserListModel: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateInstance(){
        let userObject = UserListElement(login: "John", id: 1, nodeID: "1", avatarURL: "http://google.com", gravatarID: "http://google.com", url: "http://google.com", htmlURL: "http://google.com", followersURL: "http://google.com", followingURL: "http://google.com", gistsURL: "http://google.com", starredURL: "http://google.com", subscriptionsURL: "http://google.com", organizationsURL: "http://google.com", reposURL: "http://google.com", eventsURL: "http://google.com", receivedEventsURL: "http://google.com", type: .user, siteAdmin: false, isViewed: false)
        XCTAssertNotNil(userObject)
    }
    
    func testUserModleCreateInstance(){
        let userObject = UserListElement(login: "John", id: 1, nodeID: "1", avatarURL: "http://google.com", gravatarID: "http://google.com", url: "http://google.com", htmlURL: "http://google.com", followersURL: "http://google.com", followingURL: "http://google.com", gistsURL: "http://google.com", starredURL: "http://google.com", subscriptionsURL: "http://google.com", organizationsURL: "http://google.com", reposURL: "http://google.com", eventsURL: "http://google.com", receivedEventsURL: "http://google.com", type: .user, siteAdmin: false, isViewed: false)
        var userListArr = UserListModel()
        userListArr.append(userObject)
        XCTAssertNotNil(userListArr)
        XCTAssertEqual(userListArr.count, 1)
    }
}

