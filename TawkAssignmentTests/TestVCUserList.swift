//
//  TestVCUserList.swift
//  TawkAssignmentTests
//
//  Created by Rajveer Kaur on 05/09/22.
//

import XCTest
@testable import TawkAssignment

class TestVCUserList: XCTestCase {
    var sut: VCUserList!
    override func setUpWithError() throws {
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCUserList") as! VCUserList
        _ = sut.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTableview(){
        XCTAssertNotNil(sut.tblUserList)
    }
    
    func testCellNormalDatasourceDelegate(){
        XCTAssertNotNil(sut.tblUserList.dataSource is CellUserNormalModel)
        XCTAssertNotNil(sut.tblUserList.delegate is CellUserNormalModel)
    }
   
    func testCellNoteDatasourceDelegate(){
        XCTAssertNotNil(sut.tblUserList.dataSource is CellUserNoteModel)
        XCTAssertNotNil(sut.tblUserList.delegate is CellUserNoteModel)
    }
    func testCellInvertedDatasourceDelegate(){
        XCTAssertNotNil(sut.tblUserList.dataSource is CellUserInvertedModel)
        XCTAssertNotNil(sut.tblUserList.delegate is CellUserInvertedModel)
    }
    
    func testNumberOfRows(){
        sut.viewModel = MockUserListViewModel(webservice: MockWebService(), notesRepository: MockNotesRepository(), userListRepository: MockUserListRepository())
        sut.viewModel.getAllUsers(page: 0)
        XCTAssertEqual(sut.viewModel.numberOfItems, 1)
    }
    func testSearchBarNotSearchWithEmptyString(){
        sut.viewModel = MockUserListViewModel(webservice: MockWebService(), notesRepository: MockNotesRepository(), userListRepository: MockUserListRepository())
        sut.viewModel.getAllUsers(page: 0)
        
        // get total items in list
        let totalItem = sut.viewModel.numberOfItems
        
        sut.searchBar.text = ""
        XCTAssertEqual(sut.viewModel.numberOfItems, totalItem)
        
        sut.searchBar.text = "   "
        XCTAssertEqual(sut.viewModel.numberOfItems, totalItem)
       print( sut.viewModel.numberOfItems )
    }
    func testGetUserListFromCoreDataInCaseNoInternet(){
        sut.viewModel = MockUserListViewModel(webservice: MockWebService(), notesRepository: MockNotesRepository(), userListRepository: MockUserListRepository())
        sut.viewModel = UserListViewModel(webservice: MockWebService(), notesRepository: MockNotesRepository(), userListRepository: MockUserListRepository())
        sut.viewModel.view = sut
        sut.viewModel.getAllUsers(page: 0)
        print(sut.viewModel.numberOfItems)
    }
    
}
class MockWebService: WebService {
    
}
class MockNotesRepository: NotesRepository{
    
}
class MockUserListRepository: UserListRepository{
    override func getAll(completion: @escaping ([UserListElement]?, Error?) -> Void) {
        completion([dataMockUserElement],nil)
    }
}
class MockUtilityWihNoInternet: Utility {
    override class func isInternetAvailable() -> Bool {
        return false
    }
}
class MockUtilityWihInternet: Utility {
    override class func isInternetAvailable() -> Bool {
        return true
    }
}
