//
//  CellUserNoteViewModel.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 06/09/22.
//

import Foundation

class CellUserNoteModel: TableViewCellModelProtocol {
    
    var cellIdentifier: String = "CellUserNote"
    var object: UserListElement
    
    init(object: UserListElement) {
        self.object = object
    }
}
