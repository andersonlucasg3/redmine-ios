//
//  Projects.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class ProjectsResult: BasicResult {
    @objc var projects: [Project]?
    
    func append(from project: ProjectsResult) {
        self.totalCount = project.totalCount
        self.offset = project.offset
        self.limit = project.limit
        self.projects?.append(contentsOf: project.projects ?? [])
    }
}
