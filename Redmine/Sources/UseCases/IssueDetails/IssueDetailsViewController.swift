//
//  IssueDetailsViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 24/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

typealias IssueDetailKeyValue = (key: String, value: String?)

class IssueDetailsViewController: UITableViewController {
    fileprivate weak var dataSource: DataSource<IssueDetailKeyValue>!
    fileprivate var genericDataSource: GenericDelegateDataSource!
    
    var issue: Issue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.registerCells()
        self.createDataSource()
    }
    
    fileprivate func registerCells() {
        self.tableView.register(cellClass: IssueDetailTableViewCell.self)
    }
    
    fileprivate func createDataSource() {
        let dataSource = DataSource<IssueDetailKeyValue>.init()
        dataSource.items = [
            (key: "Title:",                     value: self.issue?.name),
            (key: "Type:",                      value: self.issue?.tracker?.name),
            (key: "Situation:",                 value: self.issue?.status?.name),
            (key: "Priority:",                  value: self.issue?.priority?.name),
            (key: "Assigned to:",               value: self.issue?.assignedTo?.name),
            (key: "Author:",                    value: self.issue?.author?.name),
            (key: "Updated at:",                value: DateStringProcessor.dateString(for: self.issue?.updatedOn ?? ""))
        ].filter({ $0.value != nil })
        
        let sections = [IssueDetailSection.init(dataSource: dataSource)]
        
        self.genericDataSource = GenericDelegateDataSource.init(withSections: sections, andTableView: self.tableView)
        self.tableView.delegate = self.genericDataSource
        self.tableView.dataSource = self.genericDataSource
        self.tableView.reloadData()
        
        self.dataSource = dataSource
    }
}
