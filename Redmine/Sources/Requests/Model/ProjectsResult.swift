//
//  Projects.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class ProjectsResult: BasicResult, SpecificResultProtocol {
    typealias SpecificResult = Project
    typealias BasicResultType = ProjectsResult
    
    @objc var projects: [Project]?
    
    var results: [Project]? {
        get { return self.projects }
        set { self.projects = newValue }
    }
}
