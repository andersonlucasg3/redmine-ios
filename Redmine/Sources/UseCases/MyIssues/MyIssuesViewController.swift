//
//  MyIssuesViewController.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 10/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit

class MyIssuesViewController: SearchableTableViewController<IssuesResult, Issue, IssuesSection> {
    override var searchType: SearchType! {
        return .issues
    }
    
    override func loadMoreItemsName() -> String {
        return "Issues"
    }
    
    override func requestEndPoint() -> String {
        return Ambients.getIssuesPath(with: self.sessionController, assignedTo: "me", page: self.pageCounter?.currentPage ?? 0)
    }
}
