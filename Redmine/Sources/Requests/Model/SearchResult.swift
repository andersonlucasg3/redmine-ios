//
//  SearchResult.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 06/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class SearchResult: BasicResult {
    @objc var results: [SearchItem]?
    
    func transform<ResultType : BasicResult>() -> ResultType? {
        if ResultType.self == ProjectsResult.self {
            return self.transformProjects() as? ResultType
        } else if IssuesResult.self == ResultType.self {
            return self.transformIssues() as? ResultType
        }
        return nil
    }
    
    fileprivate func transformProjects() -> ProjectsResult {
        let result = ProjectsResult()
        result.update(from: self)
        result.projects = self.results?.map({ item in
            let project = Project.init()
            project.id = item.id
            project.name = item.title
            project.homepage = item.url
            project.subtitle = item.subtitle
            project.createdOn = item.datetime
            return project
        })
        return result
    }
    
    fileprivate func transformIssues() -> IssuesResult {
        let result = IssuesResult()
        result.update(from: self)
        result.issues = self.results?.map({ item in
            let issue = Issue.init()
            issue.id = item.id
            issue.name = item.title
            issue.subtitle = item.subtitle
            issue.createdOn = item.datetime
            return issue
        })
        return result
    }
}
