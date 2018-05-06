//
//  ProjectIssuesViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class ProjectIssuesViewController: SearchableTableViewController<IssuesResult, Issue, IssuesSection> {
    override var searchType: SearchType! {
        return .issues
    }
    
    var project: Project! {
        didSet {
            self.updateProjectName()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateProjectName()
    }
    
    fileprivate func updateProjectName() {
        self.title = self.project?.name
    }
    
    override func requestEndPoint() -> String {
        return Ambients.getIssuesPath(with: self.sessionController, forProject: self.project, page: self.pageCounter?.currentPage ?? 0)
    }
}
