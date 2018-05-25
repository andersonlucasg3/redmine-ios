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
    fileprivate weak var mainItemsDataSource: DataSource<IssueDetailKeyValue>!
    fileprivate weak var customFieldsDataSource: DataSource<IssueDetailKeyValue>!
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
        guard let issue = self.issue else { return }
        let mainItemsDataSource = DataSource<IssueDetailKeyValue>.init()
        mainItemsDataSource.items = [
            (key: "Title:",                     value: issue.name),
            (key: "Description:",               value: issue.subtitle),
            (key: "Subject:",                   value: issue.subject),
            (key: "Type:",                      value: issue.tracker?.name),
            (key: "Category:",                  value: issue.category?.name),
            (key: "Situation:",                 value: issue.status?.name),
            (key: "Done ratio:",                value: "\(issue.doneRatio)"),
            (key: "Priority:",                  value: issue.priority?.name),
            (key: "Assigned to:",               value: issue.assignedTo?.name),
            (key: "Author:",                    value: issue.author?.name),
            (key: "Started at:",                value: DateStringProcessor.dateString(for: issue.startDate ?? "")),
            (key: "Due date at:",               value: DateStringProcessor.dateString(for: issue.dueDate ?? "")),
            (key: "Created at:",                value: DateStringProcessor.dateString(for: issue.createdOn ?? "")),
            (key: "Updated at:",                value: DateStringProcessor.dateString(for: issue.updatedOn ?? ""))
        ].filter({ $0.value != nil && !$0.value!.isEmpty })
        
        let customFieldsDataSource = DataSource<IssueDetailKeyValue>.init()
        customFieldsDataSource.items = (issue.customFields?.map({ item in
            return (key: item.name ?? "", value: item.value?.joined(separator: ", ") ?? "")
        }) ?? []).filter({ $0.value != nil && !$0.value!.isEmpty })
        
        let sections = [
            IssueDetailSection.init(dataSource: mainItemsDataSource),
            IssueDetailSection.init(title: "Custom fields", dataSource: customFieldsDataSource)
        ]
        sections.enumerated().forEach({$0.element.index = $0.offset})
        
        self.genericDataSource = GenericDelegateDataSource.init(withSections: sections, andTableView: self.tableView)
        self.tableView.delegate = self.genericDataSource
        self.tableView.dataSource = self.genericDataSource
        self.tableView.reloadData()
        
        self.mainItemsDataSource = mainItemsDataSource
        self.customFieldsDataSource = customFieldsDataSource
    }
}
