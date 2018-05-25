//
//  IssueTableViewCell.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class IssueTableViewCell: UITableViewCell, Setupable {
    typealias DataType = Issue
    
    @IBOutlet fileprivate weak var ticketLabel: UILabel!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate(set) weak var timeTrackerButton: UIButton!
    
    func setup(with data: Issue) {
        self.ticketLabel.text = "\(data.id)"
        self.titleLabel.text = data.subject
    }
}
