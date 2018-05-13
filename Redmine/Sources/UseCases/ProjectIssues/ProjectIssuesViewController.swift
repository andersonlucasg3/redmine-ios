//
//  ProjectIssuesViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift
import PKHUD

class ProjectIssuesViewController: SearchableTableViewController<IssuesResult, Issue, IssuesSection> {
    fileprivate let timeTrackerController = TimeTrackerController.init()
    fileprivate lazy var interactor = IssuesTimeTrackingInteractor.init(viewController: self,
                                                                        timeTrackerController: self.timeTrackerController)
    
    fileprivate var projectRequest: Request!
    
    fileprivate var project: Project! {
        didSet {
            self.updateProjectName()
        }
    }
    
    override var searchType: SearchType! {
        return .issues
    }
    
    var projectToLoadId: String! {
        didSet {
            self.startRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateProjectName()
    }
    
    fileprivate func updateProjectName() {
        self.title = self.project?.name
    }
    
    override func loadMoreItemsName() -> String {
        return "Issues"
    }
    
    override func postSetupDataSource() {
        self.delegateDataSource.sections.map({$0 as! IssuesSection}).forEach({$0.delegate = self.interactor})
    }
    
    #if MOCKED
    override func mockedContent() -> String? {
        if self.project == nil {
            return try? String.init(contentsOfFile: Bundle.main.path(forResource: "project", ofType: "json") ?? "path")
        }
        return try? String.init(contentsOfFile: Bundle.main.path(forResource: "issues", ofType: "json") ?? "path")
    }
    #endif
    
    // MARK: Request functions
    
    override func requestEndPoint() -> String {
        guard let project = self.project else {
            return Ambients.getProjectPath(with: self.sessionController, projectId: self.projectToLoadId)
        }
        return Ambients.getIssuesPath(with: self.sessionController, forProject: project, page: self.pageCounter?.currentPage ?? 0)
    }
    
    override func overrideSearchEndPoint() -> String? {
        return Ambients.getIssuesSearchPath(with: self.sessionController, for: self.project,
                                            query: self.searchController?.searchBar.text ?? "",
                                            page: self.pageCounter?.currentPage ?? 0,
                                            searchType: .issues)
    }
    
    // MARK: RequestProtocol
    
    override func request(_ request: Request, didFinishWithContent content: String?) {
        guard let _ = self.project else {
            guard let projectResult: ProjectResult = ApiResultProcessor.processResult(content: content) else {
                self.request(request, didFailWithError: RequestError.statusCode(code: 404, content: content))
                return
            }
            self.project = projectResult.project
            self.projectRequest = nil
            self.startRefreshing()
            return
        }
        super.request(request, didFinishWithContent: content)
    }
    
    override func request(_ request: Request, didFailWithError error: Error) {
        self.projectRequest = nil
        super.request(request, didFailWithError: error)
    }
}
