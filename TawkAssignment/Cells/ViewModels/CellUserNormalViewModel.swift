//
//  CellUserNormalViewModel.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 06/09/22.
//

import Foundation

class CellUserNormalModel: TableViewCellModelProtocol {
    var cellIdentifier: String = "CellUserNormal"
    var object: UserListElement
    
    init(object: UserListElement) {
        self.object = object
    }
    
}
