//
//  LogoutCell.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 03/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class LogoutCell: UITableViewCell, Setupable {
    typealias DataType = String
    
    func setup(with data: String) {
        self.textLabel?.text = data
    }
}
