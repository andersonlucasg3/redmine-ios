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
    
    fileprivate static func getFullUrl(_ session: SessionController, path: String) -> URL {
        return URL(string: "\(session.domain)\(path)")!
    }
    
    fileprivate static func url(_ url: URL, with queryItems: [String: String]) -> URL {
        var query = URLComponents(url: url, resolvingAgainstBaseURL: false)
        query?.queryItems = queryItems.compactMap({
            return URLQueryItem(name: $0.key, value: $0.value)
        })
        return (try? query?.asURL() ?? url) ?? url
    }
    
    static func getProjectsPath(with session: SessionController, limit: Int = 25, include: String? = nil) -> String {
        var params = ["limit": "\(limit)"]
        if let include = include {
            params["include"] = include
        }
        return self.url(self.getFullUrl(session, path: self.projectsPath), with: params).absoluteString
    }
}
