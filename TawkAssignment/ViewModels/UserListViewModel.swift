//
//  UserListViewModel.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 02/09/22.
//

import Foundation
import UIKit


typealias TableViewModelOutput = (UserListViewModel.Output) -> ()

class UserListViewModel {
    var webService: WebService!
    var notesRepository: NotesRepository!
    var userListRepository: UserListRepository!
    
    init(webservice:WebService, notesRepository: NotesRepository, userListRepository: UserListRepository){
        self.webService = webservice
        self.notesRepository = notesRepository
        self.userListRepository = userListRepository
    }
    
    var view: VCUserList!
    var items: [TableViewCellModelProtocol] = []
    var output: TableViewModelOutput?
    var allUserList: [UserListElement] = [UserListElement]()
    var filteredUserList: [UserListElement] = [UserListElement](){
        didSet{
            populateList(data: filteredUserList)
        }
    }
    var pageNumber: Int = 0
    var numberOfItems: Int {
        return items.count
    }
    var isSearchActive: Bool = false
    
    func getAllUsers(page: Int){
        if Utility.isInternetAvailable() {
            Utility.showActivityIndicator(In: self.view)
            webService.getAllUsers(page: page) { resultList, err in
                DispatchQueue.main.async {
                    Utility.hideActivityIndicator()
                }
                if err == nil, resultList != nil {
                    if  let id = resultList?.last?.id as? Int {
                        self.pageNumber = id
                    }
                    self.view.isLoaded = true
                    self.allUserList += resultList!
                    self.filteredUserList += resultList!
                    print(self.filteredUserList)
                    self.userListRepository.updateRecord(data: resultList!)
//                    self.webService.getDetailFromServer(List: resultList!)
                } else {
                    self.view.showAlertWith(title: AppName, message: err?.localizedDescription ?? ErrorAlert)
                }
            }
        } else {
            //get from coredata
            self.userListRepository.getAll { arr, err in
                if err == nil, let list = arr as? [UserListElement]{
                    self.allUserList.removeAll()
                    self.filteredUserList.removeAll()
                    self.allUserList = list
                    self.filteredUserList = list
                }
            }
        }
    }
        
    
    func fetchNextPage(){
        if isSearchActive == true { return }
        getAllUsers(page: pageNumber)
    }
    
    func populateList(data: [UserListElement]) {
        self.items.removeAll()
        for i in 0..<data.count{
             notesRepository.readAvailable(id: data[i].id!){success, note in
                 if success == true{
                    self.items.append(CellUserNoteModel(object: data[i]))
              }else
                if i > 0 && i%4 == 3 {
                    self.items.append(CellUserInvertedModel(object: data[i]))
                }else{
                    self.items.append(CellUserNormalModel(object: data[i]))
                }
            
        }
        }
        print(data.count)
        output?(.reloadData)
    }
    func refreshList(){
        populateList(data: self.filteredUserList)
    }
    func refreshOnline(){
        
    }
    func getItem(at index: Int) -> TableViewCellModelProtocol {
        return items[index]
    }
    
    func didTapItem(at index: Int) {
        let passedId = filteredUserList[index].id
        let passedName = filteredUserList[index].login
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VCUserDetail") as! VCUserDetail
        vc.userName = passedName
        vc.userId = passedId
        if !Utility.isInternetAvailable(){
            UserProfileRepository().get(id: passedId!){object, err in
                if err != nil, object == nil {
                    self.view.showAlertWith(title: AppName, message: "No Profile data available offline")
                    return
                }else{
                    self.view.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else{
            view.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    enum Output {
        case reloadData
        case reloadRowAt(index: Int)
    }
    
    func searchList(searchText: String){
       let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            filteredUserList = allUserList;
            return
        }
        
        let arr1 = allUserList.filter({ obj -> Bool in
            return (obj.login?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        let arr2 = allUserList.filter ({ obj -> Bool in
           let note = self.notesRepository.read(id: obj.id!)
            return (note != nil && (note?.contains(searchText) ?? false))
        })
        filteredUserList = arr1
        filteredUserList += arr2
        
        print(filteredUserList.count)
    }
}




