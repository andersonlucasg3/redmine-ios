//
//  UserContentLoader.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 16/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

struct UserContentInfo {
    // MARK: Static definitions
    
    static func projects() -> UserContentInfo {
        return UserContentInfo(source: Ambients.getProjectsPath(with: SessionController()))
    }
    
    static func projectIssues(_ project: Project, _ assignedTo: String?) -> UserContentInfo {
        return UserContentInfo(source: Ambients.getIssuesPath(with: SessionController(),
                                                              forProject: project,
                                                              assignedTo: assignedTo))
    }
    
    // MARK: Properties definitions
    
    fileprivate var source: String
}

class UserContentLoader {
    fileprivate var currentLoadinRequest: Request!
    
    init() {
        
    }
    
    func loadAll() {
        
    }
}
