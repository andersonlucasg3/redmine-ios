//
//  Projects.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class ProjectsResult: NSObject {
    @objc var projects: [Project]?
    @objc var totalCount: Int = 0
    @objc var offset: Int = 0
    @objc var limit: Int = 0
}
