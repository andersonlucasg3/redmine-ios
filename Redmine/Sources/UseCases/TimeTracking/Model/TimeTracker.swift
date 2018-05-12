//
//  TimeTracker.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 10/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

@objc(TimeNode)
class TimeNode: NSObject {
    @objc var startTime: TimeInterval = 0.0
    @objc var endTime: TimeInterval = -1.0
    
    func duration() -> TimeInterval {
        guard self.endTime > 0.0 else {
            return Date.init().timeIntervalSince1970 - self.startTime
        }
        return self.endTime - self.startTime
    }
}

class TimeTracker: NSObject {
    @objc var timeNodes: [TimeNode]?
    @objc var issue: Issue?
    @objc var fileName: String?
    
    func duration() -> TimeInterval {
        guard let nodes = self.timeNodes else { return 0 }
        return nodes.reduce(0.0, { (result: TimeInterval, node: TimeNode) -> TimeInterval in
            return result + node.duration()
        })
    }
}
