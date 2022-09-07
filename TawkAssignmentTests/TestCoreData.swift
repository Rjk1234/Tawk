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

}
