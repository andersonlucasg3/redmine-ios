//
//  ProjectsDataSource.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class ProjectsDataSource: SearchableDataSource<Project> {
    override func isQueryValid(_ query: String, for item: Project) -> Bool {
        let lowerQuery = query.lowercased()
        return lowerQuery == "" ||
            "\(item.id)".contains(lowerQuery) ||
            (item.name ?? "").lowercased().contains(lowerQuery)
    }
}
