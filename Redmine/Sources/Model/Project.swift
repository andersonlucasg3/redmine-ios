//
//  Project.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

@objc(Project)
class Project: NSObject {
    @objc var id: Int = 0
    @objc var name: String?
    @objc var identifier: String?
    @objc var subtitle: String? // every description in json turns to subtitle
    @objc var homepage: String?
    @objc var status: Int = 0
    @objc var createdOn: String?
    @objc var updatedOn: String?
    @objc var trackers: [Track]?
}
