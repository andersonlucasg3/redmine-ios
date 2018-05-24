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
    
    func filterTimeNodesForPublishing(from tracker: TimeTracker, of user: User) -> [TimeEntry: [TimeNode]] {
        guard let nodes = tracker.timeNodes else { return [:] }
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let resultDict = nodes.reduce([:], { (result, node) -> [TimeEntry: [TimeNode]] in
            var result = result
            let nodeStartDate = dateFormatter.string(from: Date.init(timeIntervalSince1970: node.startTime))
            if let keyValue = result.first(where: {$0.key.spentOn == nodeStartDate}) {
                var value = keyValue.value
                value.append(node)
                result[keyValue.key] = value
            } else {
                let timeEntry = TimeEntry.init()
                timeEntry.hours = 0.0
                timeEntry.issueId = tracker.issue?.id ?? 0
                timeEntry.userId = user.id
                timeEntry.spentOn = nodeStartDate
                result[timeEntry] = [node]
            }
            return result
        })
        
        resultDict.forEach({
            let seconds = $0.value.reduce(0.0, {$0 + $1.duration()})
            $0.key.hours = seconds / 1.hour
        })

        return resultDict
    }
}
