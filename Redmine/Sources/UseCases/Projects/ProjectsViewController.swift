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

class ProjectsViewController: SearchableTableViewController<ProjectsResult, Project, ProjectsSection>, ProjectsSectionProtocol, UserRequestProtocol, ProjectsRequestProtocol {
    @IBOutlet fileprivate weak var projectsToggleBarButtonItem: UIBarButtonItem!
    
    fileprivate let settingsController = SettingsController.init()
    fileprivate var projectsRequest: ProjectsRequest!
    fileprivate var userRequest: UserRequest!
    
    override var searchType: SearchType! {
        return .projects
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateProjectsFilterTitle(self.settingsController.settings.projectsFilter())
    }
    
    override func requestEndPoint() -> String {
        return Ambients.getProjectsPath(with: self.sessionController, page: self.pageCounter?.currentPage ?? 0, include: "trackers")
    }
    
    override func postSetupDataSource() {
        self.delegateDataSource?.sections?.map({$0 as? ProjectsSection}).forEach({$0?.delegate = self})
    }
    
    override func loadMoreItemsName() -> String {
        return "Projects"
    }
    
    #if MOCKED
    override func mockedContent() -> String? {
        return try? String.init(contentsOfFile: Bundle.main.path(forResource: "projects", ofType: "json") ?? "path")
    }
    #endif
    
    fileprivate func updateProjectsFilterTitle(_ newFilter: ProjectsFilter) {
        self.projectsToggleBarButtonItem.title = newFilter == .myProjects ? "All Projects" : "My Projects"
    }
    
    override func executeRequest() {
        if self.settingsController.settings.projectsFilter() == .allProjects {
            super.executeRequest()
        } else {
            self.startRequestUserProfileData()
        }
    }
    
    fileprivate func startRequestUserProfileData() {
        self.userRequest = UserRequest.init(sessionController: self.sessionController)
        self.userRequest.delegate = self
        self.userRequest.start()
    }
    
    fileprivate func startRequestUserProjects(with ids: [Int]) {
        self.projectsRequest = ProjectsRequest.init(ids: ids, session: self.sessionController)
        self.projectsRequest.delegate = self
        self.projectsRequest.start()
    }
    
    @IBAction fileprivate func projectsToggleBarButtonItem(sender: UIBarButtonItem) {
        let filter: ProjectsFilter = self.settingsController.settings.projectsFilter() == .allProjects ? .myProjects : .allProjects
        self.settingsController.settings.setProjectsFilter(filter)
        self.settingsController.saveSettings()
        self.updateProjectsFilterTitle(filter)
        self.startRefreshing()
    }
    
    // MARK: ProjectsSectionProtocol
    
    func openIssues(for project: Project) {
        let projectIssues: ProjectIssuesViewController = ProjectIssuesViewController.instantiate()!
        projectIssues.projectToLoadId = "\(project.id)"
        self.navigationController?.pushViewController(projectIssues, animated: true)
    }
    
    // MARK: UserRequestProtocol
    
    func userRequest(_ request: UserRequest, didFinishWithSuccess user: User) {
        guard let projectsIds: [Int] = user.memberships?.map({$0.project?.id ?? 0}) else { return }
        self.startRequestUserProjects(with: projectsIds)
    }
    
    func userRequest(_ request: UserRequest, didFailWithError error: Error) {
        HUD.flash(.labeledError(title: "Projects", subtitle: "Failed to load projects."), delay: 1.0)
    }
    
    // MARK: ProjectsRequestProtocol
    
    func projectsRequest(_ request: ProjectsRequest, didFinishWithProjects projects: [Project]) {
        self.setupDataSourceIfPossible(with: projects)
        self.reloadTableView()
        self.endRefreshing(with: projects.count > 0)
    }
}
