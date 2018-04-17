//
//  Issue.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

@objc(Issue)
class Issue: NSObject {
    @objc var id: Int = 0
    @objc var project: IssueProject?
    @objc var tracker: IssueTracker?
    @objc var status: IssueStatus?
    @objc var priority: IssuePriority?
    @objc var author: IssueAuthor?
    @objc var assignedTo: IssueAssignment?
    @objc var fixedVersion: IssueFixedVersion?
    @objc var category: IssueCategory?
    @objc var subject: String?
    @objc var subtitle: String?
    @objc var startDate: String?
    @objc var dueDate: String?
    @objc var doneRatio: Int = 0
    @objc var customFields: [CustomField]?
    @objc var createdOn: String?
    @objc var updatedOn: String?
}

class IssueProject: Basic {}
class IssueTracker: Basic {}
class IssueStatus: Basic {}
class IssuePriority: Basic {}
class IssueAuthor: Basic {}
class IssueAssignment: Basic {}
class IssueFixedVersion: Basic {}
class IssueCategory: Basic {}
