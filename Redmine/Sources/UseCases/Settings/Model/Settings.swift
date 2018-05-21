//
//  Settings.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 20/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

enum ProjectsFilter: String {
    case allProjects = "all_projects"
    case myProjects = "my_projects"
}

class Settings: NSObject {
    @objc fileprivate var _projectsFilter: String!
    
    override init() {
        super.init()
        
        self.setProjectsFilter(.allProjects)
    }
    
    func setProjectsFilter(_ filter: ProjectsFilter) {
        self._projectsFilter = filter.rawValue
    }
    
    func projectsFilter() -> ProjectsFilter {
        return ProjectsFilter.init(rawValue: self._projectsFilter) ?? .allProjects
    }
}
