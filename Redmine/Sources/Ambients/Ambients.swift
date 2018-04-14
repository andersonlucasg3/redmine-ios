//
//  Ambients.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

struct Ambients {
    fileprivate static let projectsPath = "/projects.json"
    
    fileprivate static func getFullUrl(_ session: SessionController, path: String) -> String {
        return "\(session.domain)\(path)"
    }
    
    static func getProjectsPath(with session: SessionController) -> String {
        return self.getFullUrl(session, path: self.projectsPath)
    }
}
