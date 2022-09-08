//
//  MockURLSession.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 05/09/22.
//

import XCTest
@testable import TawkAssignment

typealias dataCompletionHandler = (Data?, URLResponse?, Error?) -> Void
class MockURLSessionDataTask: URLSessionDataTask {
    var completion: dataCompletionHandler?
    var dataToReturn: Data?
    var urlResponseToreturn: URLResponse?
    var errorToReturn: NSError?
    
    override func resume() {
        if let completion = completion {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                completion(self.dataToReturn, self.urlResponseToreturn, self.errorToReturn)
            }
        }
    }
}

class MockURLSession: URLSession {
    
    var dataTask: MockURLSessionDataTask?
    override init(){
       self.dataTask = MockURLSessionDataTask()
    }
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.dataTask?.completion = completionHandler
        return self.dataTask!
    }
}

class MockURLSessionDataTaskWithData: URLSessionDataTask {
    
    var completion: dataCompletionHandler?
    var dataToReturn: Data?
    var urlResponseToreturn: URLResponse?
    var errorToReturn: NSError?
    
    override func resume() {
        if let completion = completion {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.0){
                do{
                    let jsonData = try JSONEncoder().encode(dataMockUserElement)
                completion(jsonData, self.urlResponseToreturn, self.errorToReturn)
                }catch{
                completion(self.dataToReturn, self.urlResponseToreturn, self.errorToReturn)
                }
            }
        }
    }
}
class MockURLSessionWithData: URLSession {
    
    var dataTask: MockURLSessionDataTaskWithData?
    override init(){
       self.dataTask = MockURLSessionDataTaskWithData()
    }
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.dataTask?.completion = completionHandler
        return self.dataTask!
    }
}
let dataMockUserProfile = UserModel(login: "John", id: 1, nodeID: "1", avatarURL: "http://google.com", gravatarID: "http://google.com", url: "http://google.com", htmlURL: "http://google.com", followersURL: "http://google.com", followingURL: "http://google.com", gistsURL: "http://google.com", starredURL: "http://google.com", subscriptionsURL: "http://google.com", organizationsURL: "http://google.com", reposURL: "http://google.com", eventsURL: "http://google.com", receivedEventsURL: "http://google.com", type: "user", siteAdmin: false, name: "john doe", company: "JohnCompany", blog: "http://google.com", location: "", email: "john@yopmail.com", hireable: "No", bio: "", twitterUsername: "john", publicRepos: 1, publicGists: 1, followers: 10, following: 10, createdAt: "", updatedAt: "", note: "")

let dataMockUserElement = UserListElement(login: "John", id: 1, nodeID: "1", avatarURL: "http://google.com", gravatarID: "http://google.com", url: "http://google.com", htmlURL: "http://google.com", followersURL: "http://google.com", followingURL: "http://google.com", gistsURL: "http://google.com", starredURL: "http://google.com", subscriptionsURL: "http://google.com", organizationsURL: "http://google.com", reposURL: "http://google.com", eventsURL: "http://google.com", receivedEventsURL: "http://google.com", type: .user, siteAdmin: false, isViewed: false)

let dataMockUserElementTwo = UserListElement(login: "Smith", id: 2, nodeID: "2", avatarURL: "http://google.com", gravatarID: "http://google.com", url: "http://google.com", htmlURL: "http://google.com", followersURL: "http://google.com", followingURL: "http://google.com", gistsURL: "http://google.com", starredURL: "http://google.com", subscriptionsURL: "http://google.com", organizationsURL: "http://google.com", reposURL: "http://google.com", eventsURL: "http://google.com", receivedEventsURL: "http://google.com", type: .user, siteAdmin: false, isViewed: false)

let dataMockUserElementThree = UserListElement(login: "Jesica", id: 3, nodeID: "3", avatarURL: "http://google.com", gravatarID: "http://google.com", url: "http://google.com", htmlURL: "http://google.com", followersURL: "http://google.com", followingURL: "http://google.com", gistsURL: "http://google.com", starredURL: "http://google.com", subscriptionsURL: "http://google.com", organizationsURL: "http://google.com", reposURL: "http://google.com", eventsURL: "http://google.com", receivedEventsURL: "http://google.com", type: .user, siteAdmin: false, isViewed: false)

