//
//  ProjectIssuesViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class ProjectIssuesViewController: RefreshableTableViewController, SearchableViewControllerProtocol, RequestProtocol, UISearchResultsUpdating {
    typealias SearchableType = Issue
    typealias SectionType = IssuesSection
    
    fileprivate let sessionController = SessionController()
    
    weak var searchController: UISearchController!
    weak var dataSource: SearchableDataSource<Issue>!
    var delegateDataSource: GenericDelegateDataSource!
    
    fileprivate var issuesRequest: Request?
    
    fileprivate var issues: IssuesResult!
    
    var project: Project! {
        didSet {
            self.updateProjectName()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateProjectName()
        self.setupSearchController()
        self.setupDataSourceIfPossible()
    }
    
    override func clearCurrentContent() {
        self.pageCounter = nil
        self.issues = nil
    }
    
    fileprivate func updateProjectName() {
        self.title = self.project?.name
    }
    
    fileprivate func setupDataSourceIfPossible() {
        if let issues = self.issues {
            self.setupDataSourceIfPossible(with: issues.issues ?? [])
        } else {
            self.startRefreshing()
        }
    }
    
    fileprivate func createIssuesRequest() -> Request {
        let request = Request(url: Ambients.getIssuesPath(with: self.sessionController, forProject: self.project, page: self.pageCounter?.currentPage ?? 0), method: .get)
        request.delegate = self
        request.addBasicAuthorizationHeader(credentials: self.sessionController.credentials)
        return request
    }
    
    override func startRefreshing() {
        super.startRefreshing()
        self.issuesRequest = self.createIssuesRequest()
        self.issuesRequest?.start()
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        guard let issues: IssuesResult = ApiResultProcessor.processResult(content: content) else {
            self.request(request, didFailWithError: .statusCode(code: 404, content: content))
            return
        }
        
        if self.issues == nil {
            self.issues = issues
        } else {
            self.issues.append(from: issues)
        }
        
        self.setupPageCounterIfNeeded(totalItems: self.issues.totalCount)
        self.setupDataSourceIfPossible()
        self.reloadTableView()
        
        self.endRefreshing(with: true)
    }
    
    func request(_ request: Request, didFailWithError error: RequestError) {
        self.endRefreshing(with: false)
    }
    
    // MARK: UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        self.updateSearch(for: searchController)
    }
}
