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
    @IBOutlet fileprivate weak var typeLabel: UILabel!
    @IBOutlet fileprivate weak var situationLabel: UILabel!
    @IBOutlet fileprivate weak var priorityLabel: UILabel!
    @IBOutlet fileprivate weak var authorLabel: UILabel!
    @IBOutlet fileprivate weak var updatedAtLabel: UILabel!
    
    func setup(with data: Issue) {
        self.ticketLabel.text = "\(data.id)"
        self.titleLabel.text = data.subject
        self.typeLabel.text = data.tracker?.name
        self.situationLabel.text = data.status?.name
        self.priorityLabel.text = data.priority?.name
        self.authorLabel.text = data.author?.name
        self.updatedAtLabel.text = DateStringProcessor.dateString(for: data.updatedOn ?? "")
    }
}
