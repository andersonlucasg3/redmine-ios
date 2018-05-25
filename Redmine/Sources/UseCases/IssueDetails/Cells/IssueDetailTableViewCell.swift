//
//  IssueDetailTableViewCell.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class IssueDetailTableViewCell: UITableViewCell, Setupable {
    typealias DataType = IssueDetailKeyValue
    
    @IBOutlet fileprivate(set) weak var keyLabel: UILabel!
    @IBOutlet fileprivate(set) weak var valueLabel: UILabel!
    @IBOutlet fileprivate(set) weak var lineView: UIView!
    
    func setup(with data: IssueDetailKeyValue) {
        self.keyLabel?.text = data.key
        self.valueLabel?.text = data.value
    }
}
