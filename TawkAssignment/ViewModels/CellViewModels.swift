//
//  CellViewModels.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 05/09/22.
//

import Foundation
import UIKit


protocol TableViewCellProtocol {
    func populate(with data: TableViewCellModelProtocol)
}

protocol TableViewCellModelProtocol {
    var cellIdentifier: String { get }
}
