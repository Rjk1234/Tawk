//
//  CellUserInvertedViewModel.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 06/09/22.
//

import Foundation

class CellUserInvertedModel: TableViewCellModelProtocol {
    
    var cellIdentifier: String = "CellUserInverted"
    var object: UserListElement
    
    init(object: UserListElement) {
        self.object = object
    }
}
