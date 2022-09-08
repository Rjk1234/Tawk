//
//  MockUserListViewModel.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 05/09/22.
//

import XCTest
@testable import TawkAssignment

class MockUserListViewModel: UserListViewModel {
    
    var numberOfITemExpectation: XCTestExpectation?
    var getUserExpectation: XCTestExpectation?

    override var numberOfItems: Int{
        numberOfITemExpectation?.fulfill()
        return self.items.count
    }
    
    override func getAllUsers(page: Int) {
        self.items.append(CellUserNormalModel(object: dataMockUserElement))
        getUserExpectation?.fulfill()
    }
    
    
}
