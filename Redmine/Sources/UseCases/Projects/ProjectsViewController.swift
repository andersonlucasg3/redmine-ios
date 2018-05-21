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

class ProjectsViewController: SearchableTableViewController<ProjectsResult, Project, ProjectsSection>, ProjectsSectionProtocol, UserRequestProtocol {
    @IBOutlet fileprivate weak var projectsToggleBarButtonItem: UIBarButtonItem!
    
    fileprivate let settingsController = SettingsController.init()
    fileprivate lazy var userRequest: UserRequest = UserRequest.init(sessionController: self.sessionController)
    
    override var searchType: SearchType! {
        return .projects
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
        self.projectsToggleBarButtonItem.title = newFilter == .allProjects ? "All Projects" : "My Projects"
    }
    
    fileprivate func executeFilterAction(_ newFilter: ProjectsFilter) {
        if newFilter == .allProjects {
            self.startRefreshing()
        } else {
            
        }
    }
    
    @IBAction fileprivate func projectsToggleBarButtonItem(sender: UIBarButtonItem) {
        let filter: ProjectsFilter = self.settingsController.settings.projectsFilter() == .allProjects ? .myProjects : .allProjects
        self.settingsController.settings.setProjectsFilter(filter)
        self.settingsController.saveSettings()
        self.updateProjectsFilterTitle(filter)
        self.executeFilterAction(filter)
    }
    
    // MARK: ProjectsSectionProtocol
    
    func openIssues(for project: Project) {
        let projectIssues: ProjectIssuesViewController = ProjectIssuesViewController.instantiate()!
        projectIssues.projectToLoadId = "\(project.id)"
        self.navigationController?.pushViewController(projectIssues, animated: true)
    }
    
    // MARK: UserRequestProtocol
    
    func userRequest(_ request: UserRequest, didFinishWithSuccess user: User) {
        self.setupDataSourceIfPossible(with: user.memberships)
    }
    
    func userRequest(_ request: UserRequest, didFailWithError error: Error) {
        
    }
}
