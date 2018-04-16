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

class ProjectsViewController: RefreshableTableViewController, ProjectsSectionProtocol, RequestProtocol {
    fileprivate var projectsDataSource: GenericDelegateDataSource!
    fileprivate let sessionController = SessionController()
    
    fileprivate lazy var projectsRequest: Request = {
        let request = Request(url: Ambients.getProjectsPath(with: self.sessionController, include: "trackers"), method: .get)
        request.delegate = self
        request.addBasicAuthorizationHeader(credentials: self.sessionController.credentials)
        return request
    }()
    
    var project: ProjectsResult! {
        didSet {
            self.setupDataSourceIfPossible()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDataSourceIfPossible()
    }
    
    fileprivate func setupDataSourceIfPossible() {
        if let project = self.project {
            if let tableView = self.tableView, project.projects?.count ?? 0 > 0 {
                let dataSource: DataSource<Project> = DataSource()
                dataSource.items = project.projects
                
                let sections = [ProjectsSection(dataSource: dataSource)]
                self.projectsDataSource = GenericDelegateDataSource(withSections: sections, andTableView: tableView)
                sections.forEach({$0.delegate = self})
                
                tableView.delegate = self.projectsDataSource
                tableView.dataSource = self.projectsDataSource
            } else {
                self.showNoContentBackgroundView()
            }
        } else {
            self.startRefreshing()
        }
    }
    
    override func startRefreshing() {
        super.startRefreshing()
        self.projectsRequest.start()
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        guard let project: ProjectsResult = ApiResultProcessor.processResult(content: content) else {
            self.request(request, didFailWithError: .statusCode(code: 404, content: content))
            return
        }
        
        self.project = project
        self.setupDataSourceIfPossible()
        self.reloadTableViewAnimated()
        
        self.endRefreshing(with: true)
    }
    
    func request(_ request: Request, didFailWithError error: RequestError) {
        print(#function)
        print(error)
        
        self.endRefreshing(with: false)
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
