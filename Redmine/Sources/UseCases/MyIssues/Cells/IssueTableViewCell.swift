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
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var tableViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet fileprivate(set) weak var timeTrackerButton: UIButton!
    
    fileprivate var issueDetailDataSource: GenericDelegateDataSource!
    
    func setup(with data: Issue) {
        self.ticketLabel.text = "\(data.id)"
        self.titleLabel.text = data.subject
        
        self.setupTableViewAndDataSource(for: data)
    }
    
    fileprivate func setupTableViewAndDataSource(for issue: Issue) {
        self.tableView.allowsSelection = false
        
        let dataSource: DataSource<IssueDetailKeyValue> = DataSource()
        dataSource.items = [
            (key: "Type:",                      value: issue.tracker?.name),
            (key: "Situation:",                 value: issue.status?.name),
            (key: "Priority:",                  value: issue.priority?.name),
            (key: "Assigned to:",               value: issue.assignedTo?.name),
            (key: "Author:",                    value: issue.author?.name),
            (key: "Updated at:",                value: DateStringProcessor.dateString(for: issue.updatedOn ?? ""))
        ].filter({ $0.value != nil })
        
        self.issueDetailDataSource = GenericDelegateDataSource(withSections: [IssueDetailSection(dataSource: dataSource)],
                                                               andTableView: self.tableView)
        self.tableView.delegate = self.issueDetailDataSource
        self.tableView.dataSource = self.issueDetailDataSource
        self.tableView.reloadData()
        self.tableViewHeightConstriant.constant = self.tableView.contentSize.height
    }
}
