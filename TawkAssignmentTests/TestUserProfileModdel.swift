//
//  TestUserProfileModdel.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 07/09/22.
//

import XCTest
@testable import TawkAssignment

class TestUserProfileModdel: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateInstance(){
        let userProfileObject = UserModel(login: "John", id: 1, nodeID: "1", avatarURL: "http://google.com", gravatarID: "http://google.com", url: "http://google.com", htmlURL: "http://google.com", followersURL: "http://google.com", followingURL: "http://google.com", gistsURL: "http://google.com", starredURL: "http://google.com", subscriptionsURL: "http://google.com", organizationsURL: "http://google.com", reposURL: "http://google.com", eventsURL: "http://google.com", receivedEventsURL: "http://google.com", type: "user", siteAdmin: false, name: "john doe", company: "JohnCompany", blog: "http://google.com", location: "", email: "john@yopmail.com", hireable: "No", bio: "", twitterUsername: "john", publicRepos: 1, publicGists: 1, followers: 10, following: 10, createdAt: "", updatedAt: "", note: "")
        XCTAssertNotNil(userProfileObject)
    }

}
