//
//  ProjectsViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift
import PKHUD

class ProjectsViewController: SearchableTableViewController<ProjectsResult, Project, ProjectsSection>, ProjectsSectionProtocol {
    override var searchType: SearchType! {
        return .projects
    }
    
    override func requestEndPoint() -> String {
        return Ambients.getProjectsPath(with: self.sessionController, page: self.pageCounter?.currentPage ?? 0, include: "trackers")
    }
    
    override func postSetupDataSource() {
        self.delegateDataSource?.sections?.map({$0 as? ProjectsSection}).forEach({$0?.delegate = self})
    }
    
    // MARK: ProjectsSectionProtocol
    
    func openProjectInfo(for project: Project) {
        // TODO: Show project info
    }
    
    func openIssues(for project: Project) {
        let projectIssues: ProjectIssuesViewController = ProjectIssuesViewController.instantiate()!
        projectIssues.project = project
        self.navigationController?.pushViewController(projectIssues, animated: true)
    }
}
