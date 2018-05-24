//
//  TimeEntry.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 22/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class TimeEntryBottle: NSObject {
    @objc var timeEntry: TimeEntry?
}

class TimeEntry: NSObject {
    @objc var issueId: Int = 0
    @objc var userId: Int = 0
    @objc var spentOn: String?
    @objc var hours: Double = 0.0
}
