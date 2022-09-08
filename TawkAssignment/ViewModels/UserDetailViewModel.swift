//
//  UserDetailViewModel.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 04/09/22.
//

import Foundation
import UIKit
import Combine

class UserDetailViewModel: ObservableObject{
    var view: VCUserDetail!
    var webService: WebService!
    var notesRepository: NotesRepository!
    var userListRepository: UserListRepository!
    var userProfileRepository: UserProfileRepository!
    
    init(
        webservice:WebService,
        notesRepository: NotesRepository,
        userListRepository: UserListRepository,
        userProfileRepository: UserProfileRepository
    ){
        self.webService = webservice
        self.notesRepository = notesRepository
        self.userListRepository = userListRepository
        self.userProfileRepository = userProfileRepository
    }
    
    var receiveDetail: ((UserModel?, Error?) -> Void)?
    
    func getDetailBy(id:Int, name: String ){
        userListRepository.setView(id: id){success,err in }
        if Utility.isInternetAvailable() {
            Utility.showActivityIndicator(In: self.view)
            webService.getUserProfileWith(Name: name) { result, error in
                DispatchQueue.main.async {
                    Utility.hideActivityIndicator()
                }
                
                if error == nil, result != nil {
                    self.view.userObject = result!
                    self.userProfileRepository.update(object: result!)
                }
                
            }
        } else {
            userProfileRepository.get(id: id){ object,err in
                if err == nil, object != nil {
                    self.view.userObject = object!
                }
            }
        }
        notesRepository.readAvailable(id: id){success, note in
            if success == true {
                self.view.tvNote.text = note ?? ""
            }
        }
    }
    
    func addNotesTo(id: Int, text: String) {
        notesRepository.save(id: id, note: text){success, error in
            if success {
                self.view.showAlertWith(title: AppName, message: "Note saved")
            } else if error != nil{
                self.view.showAlertWith(title: AppName, message: "Note not saved")
            }
        }
    }
    
}
