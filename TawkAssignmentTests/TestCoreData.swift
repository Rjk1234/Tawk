//
//  TestCoreData.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 07/09/22.
//

import XCTest
@testable import TawkAssignment

class TestCoreData: XCTestCase {

    var coreDataStack: CoreDataStack!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = CoreDataStack.sharedInstance
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCoreDataInit(){
        let persistantContainer = coreDataStack.persistentContainer
        XCTAssertNotNil(persistantContainer)
    }
    
    func testReadContext(){
        let context = coreDataStack.readManagedObjectContext
        XCTAssertNotNil(context)
    }
    
    func testWriteContext(){
        let context = coreDataStack.writeManagedObjectContext
        XCTAssertNotNil(context)
    }

    func testFetchFromNoteRepository(){
        let repository = NotesRepository()
        let getNoteExpectation: XCTestExpectation = XCTestExpectation(description: "GetNotes")
        repository.readAvailable(id: 1) { success, note in
            getNoteExpectation.fulfill()
        }
    }
    func testFetchFromUserRepository(){
        let repository = UserListRepository()
        let getNoteExpectation: XCTestExpectation = XCTestExpectation(description: "GetUserList")
        repository.getAll() { list, error in
            getNoteExpectation.fulfill()
        }
    }
    func testFetchFromProfileRepository(){
        let repository = UserProfileRepository()
        let getNoteExpectation: XCTestExpectation = XCTestExpectation(description: "GetProfile")
        repository.get(id: 1) { object, err in
            getNoteExpectation.fulfill()
        }
    }
    
}
