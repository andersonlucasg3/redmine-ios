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

class ProjectsViewController: RefreshableTableViewController, SearchableViewControllerProtocol,
        ProjectsSectionProtocol, RequestProtocol, UISearchResultsUpdating {
    typealias SearchableType = Project
    typealias SectionType = ProjectsSection
    
    fileprivate let sessionController = SessionController()
    
    fileprivate lazy var projectsRequest: Request = {
        let request = Request(url: Ambients.getProjectsPath(with: self.sessionController, include: "trackers"), method: .get)
        request.delegate = self
        request.addBasicAuthorizationHeader(credentials: self.sessionController.credentials)
        return request
    }()
    
    weak var searchController: UISearchController!
    weak var dataSource: SearchableDataSource<Project>!
    var delegateDataSource: GenericDelegateDataSource!
    
    var project: ProjectsResult!
    
    override var shouldSetupRefreshControl: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController()
        self.setupDataSourceIfPossible()
    }
    
    fileprivate func setupDataSourceIfPossible() {
        if let project = self.project {
            self.setupDataSourceIfPossible(with: project.projects ?? [])
            self.delegateDataSource.sections.map({$0 as? ProjectsSection}).forEach({$0?.delegate = self})
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
        self.reloadTableView()
        
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
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for controller: UISearchController) {
        self.updateSearch(for: controller)
    }
}
