//
//  TimeHistoryProcessor.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class TimeHistoryProcessor {
    func dayId(for date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    func filterTimeNodes(for tracker: TimeTracker) -> [String: [TimeNode]] {
        guard let nodes = tracker.timeNodes else { return [:] }
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "dd/MM"
        return Dictionary<String, [TimeNode]>.init(grouping: nodes, by: { (node) -> String in
            let date = Date.init(timeIntervalSince1970: node.startTime)
            let dayId = self.dayId(for: date)
            let todayId = self.dayId(for: Date())
            if dayId == todayId {
                return "Today"
            } else if todayId - dayId == 1 {
                return "Yesterday"
            }
            return dateFormatter.string(from: date)
        })
    }
}
