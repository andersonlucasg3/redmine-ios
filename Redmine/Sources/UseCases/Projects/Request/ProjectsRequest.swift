//
//  ProjectsRequest.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 21/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

protocol ProjectsRequestProtocol: class {
    func projectsRequest(_ request: ProjectsRequest, didFinishWithProjects projects: [Project])
}

class ProjectsRequest: RequestProtocol {
    fileprivate var ids: [Int]
    fileprivate let session: SessionController

    fileprivate var request: Request!
    fileprivate var loadedProjects: [Project] = []
    
    fileprivate var currentLoadingId: Int = 0
    
    weak var delegate: ProjectsRequestProtocol?
    
    init(ids: [Int], session: SessionController) {
        self.ids = ids
        self.session = session
    }
    
    func start() {
        self.startOrFinish()
    }
    
    fileprivate func startOrFinish() {
        if self.hasProjectToLoad() {
            self.prepare()
            self.startRequesting()
        } else {
            self.dispatchFinish()
        }
    }
    
    fileprivate func startRequesting() {
        self.request.start()
    }
    
    fileprivate func hasProjectToLoad() -> Bool {
        return self.ids.count > 0
    }
    
    fileprivate func prepare() {
        self.currentLoadingId = self.ids.removeFirst()
        self.createRequest()
    }
    
    fileprivate func createRequest() {
        self.request = Request.init(url: Ambients.getProjectPath(with: self.session, projectId: "\(self.currentLoadingId)"), method: .get)
        self.request.addHeader(for: "X-Redmine-API-Key", with: self.session.user?.apiKey ?? "")
        self.request.delegate = self
    }
    
    fileprivate func dispatchFinish() {
        self.delegate?.projectsRequest(self, didFinishWithProjects: self.loadedProjects)
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        guard
            let projectResult: ProjectResult = ApiResultProcessor.processResult(content: content),
            let project = projectResult.project
        else {
            self.request(request, didFailWithError: RequestError.statusCode(code: 404, content: content))
            return
        }
        
        self.loadedProjects.append(project)
        
        self.startOrFinish()
    }
    
    func request(_ request: Request, didFailWithError error: Error) {
        self.startOrFinish()
    }
}
