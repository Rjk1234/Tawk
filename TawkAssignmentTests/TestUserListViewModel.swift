//
//  TestUserListViewModel.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 07/09/22.
//

import XCTest
@testable import TawkAssignment

class TestUserListViewModel: XCTestCase {
    var sut: VCUserList!
    var VMUnderTest : UserListViewModel!
    
    override func setUpWithError() throws {
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCUserList") as! VCUserList
        _ = sut.view
        VMUnderTest = sut.viewModel
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewModelNotNil(){
        XCTAssertNotNil(VMUnderTest)
    }
    
    func testUnionOFArrayWithDuplicate(){
        // create duplicate data array
        let element = dataMockUserElement
        let arrWithDuplicateData = [element, element]
        
        // filter using unique function
        let arrWithOutDuplicateData = VMUnderTest.unique(elements: arrWithDuplicateData)
        
        //out put should be one data
        XCTAssertEqual(arrWithOutDuplicateData.count, 1)
    }
    
    func testMapToRefresh(){
        // create list with preload elements
        VMUnderTest.allUserList.removeAll()
        VMUnderTest.allUserList = [dataMockUserElement, dataMockUserElementTwo]
        
        // mapping with new list
        let newList: [UserListElement] = [dataMockUserElementTwo, dataMockUserElementThree]
        VMUnderTest.mapToRefresh(resultList: newList)
       
        // output should be count 3 with no duplicate
        XCTAssertEqual(VMUnderTest.allUserList.count, 3)
    }
    

    

}
