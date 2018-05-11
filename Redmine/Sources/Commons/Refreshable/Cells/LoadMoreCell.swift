//
//  LoadMoreCell.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 04/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class LoadMoreCell: UITableViewCell, Setupable {
    typealias DataType = String
    
    func setup(with data: String) {
        self.textLabel?.text = "Load more \(data)"
    }
}
