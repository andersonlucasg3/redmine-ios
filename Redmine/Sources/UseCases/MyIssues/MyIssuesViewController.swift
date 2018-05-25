//
//  MyIssuesViewController.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 10/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit

class MyIssuesViewController: SearchableTableViewController<IssuesResult, Issue, IssuesSection> {
    fileprivate lazy var timeTrackerController = TimeTrackerController.init(with: self.sessionController)
    fileprivate lazy var interactor = IssuesTimeTrackingInteractor.init(viewController: self,
                                                                        timeTrackerController: self.timeTrackerController)
    
    override var searchType: SearchType! {
        return .issues
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerCells()
    }
    
    fileprivate func registerCells() {
        self.tableView.register(cellClass: IssueTableViewCell.self)
    }
    
    override func loadMoreItemsName() -> String {
        return "Issues"
    }
    
    override func requestEndPoint() -> String {
        return Ambients.getIssuesPath(with: self.sessionController, assignedTo: "me", page: self.pageCounter?.currentPage ?? 0)
    }
    
    override func postSetupDataSource() {
        self.delegateDataSource.sections.compactMap({$0 as? IssuesSection}).forEach({$0.delegate = self.interactor})
    }
    
    #if MOCKED
    override func mockedContent() -> String? {
        return try? String.init(contentsOfFile: Bundle.main.path(forResource: "issues", ofType: "json") ?? "path")
    }
    #endif
    
    // MARK: GenericDelegateDataSourceProtocol
    
    override func didSelectItem(at indexPath: IndexPath) {
        let issue: Issue = self.dataSource.getItem(for: indexPath.row)
        let details = IssueDetailsViewController.instantiate()!
        details.issue = issue
        self.navigationController?.pushViewController(details, animated: true)
    }
}
