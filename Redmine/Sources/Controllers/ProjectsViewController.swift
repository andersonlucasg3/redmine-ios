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

class ProjectsViewController: UIViewController, GenericDelegateDataSourceProtocol, RequestProtocol {
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var projectsDataSource: GenericDelegateDataSource!
    
    fileprivate let sessionController = SessionController()
    
    fileprivate lazy var projectsRequest: Request = {
        let request = Request(url: Ambients.getProjectsPath(with: self.sessionController), method: .get)
        request.delegate = self
        request.addBasicAuthorizationHeader(credentials: self.sessionController.credentials)
        return request
    }()
    
    var project: ProjectResult! {
        didSet {
            self.setupDataSourceIfPossible()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupDataSourceIfPossible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadTableViewAnimated()
    }
    
    fileprivate func reloadTableViewAnimated() {
        self.tableView?.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    fileprivate func setupDataSourceIfPossible() {
        if let project = self.project {
            if let tableView = self.tableView {
                let dataSource: DataSource<Project> = DataSource()
                dataSource.items = project.projects
                
                let sections = [ProjectsSection(dataSource: dataSource)]
                self.projectsDataSource = GenericDelegateDataSource(withSections: sections, andTableView: tableView)
                self.projectsDataSource.delegate = self
                
                self.tableView.delegate = self.projectsDataSource
                self.tableView.dataSource = self.projectsDataSource
            }
        } else {
            self.loadProjects()
        }
    }
    
    fileprivate func loadProjects() {
        HUD.show(.progress)
        
        self.projectsRequest.start()
    }
    
    // MARK: GenericDelegateDataSourceProtocol
    
    func didSelectItem(at indexPath: IndexPath) {
        // TODO: project selected
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        guard let project: ProjectResult = ApiResultProcessor.processResult(content: content) else {
            self.request(request, didFailWithError: .statusCode(code: 404, content: content))
            return
        }
        
        self.project = project
        self.setupDataSourceIfPossible()
        self.reloadTableViewAnimated()
        
        HUD.show(.success)
        HUD.hide(afterDelay: 1.0)
    }
    
    func request(_ request: Request, didFailWithError error: RequestError) {
        print(#function)
        print(error)
        
        HUD.show(.error)
        HUD.hide(afterDelay: 1.0)
    }
}
