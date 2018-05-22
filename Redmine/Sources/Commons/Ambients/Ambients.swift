//
//  Ambients.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

enum SearchType: String {
    case projects = "projects"
    case issues = "issues"
}

enum SearchParameters: String {
    case utf8 = "utf8"
    case query = "q"
    case scope = "scope"
    case allWords = "all_words"
    case titlesOnly = "titles_only"
    case attachments = "attachments"
    case options = "options"
    case commit = "commit"
}

struct Ambients {
    fileprivate static let loginPath = "/users/current.json"
    fileprivate static let projectsPath = "/projects.json"
    fileprivate static let issuesPath = "/issues.json"
    fileprivate static let searchPath = "/search.json"
    
    fileprivate static func projectPath(projectId: String) -> String { return "/projects/\(projectId).json" }
    fileprivate static func searchProjectIssuesPath(projectIdentifier: String) -> String { return "/projects/\(projectIdentifier)/search.json" }
    
    fileprivate static func getFullUrl(_ session: SessionController, path: String) -> URL {
        return URL(string: "\(session.domain)\(path)")!
    }
    
    fileprivate static func url(_ url: URL, with queryItems: [String: String]?) -> String {
        guard let queryItems = queryItems else { return url.absoluteString }
        
        var query = URLComponents(url: url, resolvingAgainstBaseURL: false)
        query?.queryItems = queryItems.compactMap({
            return URLQueryItem(name: $0.key, value: $0.value)
        })
        
        return ( (try? query?.asURL() ?? url) ?? url ).absoluteString
    }
    
    fileprivate static func getDefaultParams(_ limit: Int?, _ page: Int?, _ include: String?) -> [String: String] {
        var params: [String: String] = [:]
        if let limit = limit {
            params["limit"] = "\(limit)"
            if let page = page {
                params["offset"] = "\(page * limit)"
            }
        }
        if let include = include {
            params["include"] = include
        }
        return params
    }
    
    static func getLoginPath(with session: SessionController) -> String {
        return self.url(self.getFullUrl(session, path: self.loginPath), with: self.getDefaultParams(nil, nil, "memberships,groups"))
    }
    
    static func getProjectsPath(with session: SessionController, limit: Int = ITEMS_PER_PAGE, page: Int = 0, include: String? = nil) -> String {
        return self.url(self.getFullUrl(session, path: self.projectsPath), with: self.getDefaultParams(limit, page, include))
    }
    
    static func getProjectPath(with session: SessionController, projectId: String, include: String? = nil) -> String {
        return self.url(self.getFullUrl(session, path: self.projectPath(projectId: projectId)), with: self.getDefaultParams(nil, nil, include))
    }
    
    static func getIssuesPath(with session: SessionController, forProject project: Project? = nil, assignedTo: String? = nil, limit: Int = ITEMS_PER_PAGE, page: Int = 0, include: String? = nil) -> String {
        var params = self.getDefaultParams(limit, page, include)
        if let project = project {
            params["project_id"] = "\(project.id)"
            if let trackers = project.trackers, let tracker = trackers.first {
                params["tracker_id"] = "\(tracker.id)"
            }
        }
        if let assignedTo = assignedTo {
            params["assigned_to_id"] = assignedTo
        }
        return self.url(self.getFullUrl(session, path: self.issuesPath), with: params)
    }
    
    fileprivate static func getSearchParams(query: String, limit: Int, page: Int, include: String?, searchType: SearchType) -> [String: String] {
        var params = self.getDefaultParams(limit, page, include)
        params[searchType.rawValue] = "1"
        params[SearchParameters.utf8.rawValue] = "%E2%9C%93"
        params[SearchParameters.query.rawValue] = query
        params[SearchParameters.scope.rawValue] = "all"
        params[SearchParameters.allWords.rawValue] = "1"
        params[SearchParameters.titlesOnly.rawValue] = ""
        params[SearchParameters.attachments.rawValue] = "0"
        params[SearchParameters.options.rawValue] = "0"
        params[SearchParameters.commit.rawValue] = "Send"
        return params
    }
    
    static func getSearchPath(with session: SessionController, query: String, limit: Int = ITEMS_PER_PAGE, page: Int = 0, searchType: SearchType) -> String {
        let params = self.getSearchParams(query: query, limit: limit, page: page, include: nil, searchType: searchType)
        return self.url(self.getFullUrl(session, path: self.searchPath), with: params)
    }
    
    static func getIssuesSearchPath(with session: SessionController, for project: Project, query: String, limit: Int = ITEMS_PER_PAGE, page: Int = 0, searchType: SearchType) -> String {
        let params = self.getSearchParams(query: query, limit: limit, page: page, include: nil, searchType: searchType)
        return self.url(self.getFullUrl(session, path: self.searchProjectIssuesPath(projectIdentifier: project.identifier ?? "unknown")), with: params)
    }
}
