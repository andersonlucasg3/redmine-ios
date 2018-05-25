//
//  TimeTrackerController.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 10/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import FileKit
import Swift_Json
import SwiftyTimer

class TimeTrackerController {
    fileprivate static var timeTrackers: [TimeTracker]!
    
    fileprivate var trackersPath: Path!
    
    fileprivate let timeTrackersSortBlock = { (left: TimeTracker, right: TimeTracker) -> Bool in
        return left.timeNodes?.last?.startTime ?? 0.0 > right.timeNodes?.last?.startTime ?? 0.0
    }
    
    fileprivate(set) var currentTimeTrackers: [TimeTracker]! {
        get { return TimeTrackerController.timeTrackers }
        set { TimeTrackerController.timeTrackers = newValue }
    }
    
    var runningTracker: TimeTracker? {
        return self.findRunningTracker()
    }
    
    init(with sessionController: SessionController) {
        let userIdentifier = self.userIdentifier(sessionController)
        self.trackersPath = Path.userCaches + "trackers" + userIdentifier
        print("[TIMETRACKER] Initializing time tracker with user identifier: \(userIdentifier)")
        print("[TIMETRACKER] User's trackers folder: \(self.trackersPath.description)")
        
        try? self.trackersPath.createDirectory(withIntermediateDirectories: true)
        if TimeTrackerController.timeTrackers == nil {
            TimeTrackerController.timeTrackers = self.loadFiles().sorted(by: self.timeTrackersSortBlock)
        }
    }
    
    fileprivate func userIdentifier(_ sessionController: SessionController) -> String {
        let server = sessionController.domain.replacingOccurrences(of: "http://", with: "")
                        .replacingOccurrences(of: "https://", with: "").slugify()
        let userLogin = (sessionController.user?.login ?? "unknown").slugify()
        return "\(server)-\(userLogin)"
    }
    
    fileprivate func loadFiles() -> [TimeTracker] {
        let filteredChildren: [Path] = self.trackersPath.children().filter({ (item: Path) in
            let regular = item.isRegular
            let isDotFile = item.fileName.starts(with: ".")
            return regular && !isDotFile
        })
        let parser = JsonParser.init()
        return filteredChildren.compactMap({ item in
            let jsonString = try? String.init(contentsOfFile: item.description, encoding: .utf8)
            return parser.parse(string: jsonString ?? "")
        })
    }
    
    @discardableResult
    func startTracker(for issue: Issue) -> TimeTracker {
        self.finishRunningTracker()
        let tracker = self.createOrRecoverTracker(issue)
        self.createTimeNode(tracker)
        self.saveAndAddTracker(tracker)
        return tracker
    }
    
    func pauseTracker(_ tracker: TimeTracker) {
        self.finishRunningNode(tracker)
        self.saveTracker(tracker)
    }
    
    func continueTracker(_ tracker: TimeTracker) {
        guard self.findRunningNode(tracker) == nil else { return }
        self.createTimeNode(tracker)
        self.sortTrackers()
        self.saveTracker(tracker)
    }
    
    func endTracker(_ tracker: TimeTracker) {
        let filePath = self.trackersPath + tracker.fileName!
        try! filePath.deleteFile()
        if let index = self.currentTimeTrackers.index(of: tracker) {
            self.currentTimeTrackers.remove(at: index)
        }
    }
    
    func remove(nodes: [TimeNode], from tracker: TimeTracker) {
        tracker.timeNodes = Array(Set(tracker.timeNodes ?? []).subtracting(nodes))
        self.saveTracker(tracker)
    }
    
    fileprivate func sortTrackers() {
        self.currentTimeTrackers.sort(by: self.timeTrackersSortBlock)
    }
    
    fileprivate func findRunningTracker() -> TimeTracker? {
        return self.currentTimeTrackers.first(where: {self.findRunningNode($0) != nil})
    }
    
    fileprivate func findRunningNode(_ tracker: TimeTracker) -> TimeNode? {
        guard let nodes = tracker.timeNodes else { return nil }
        guard let node = nodes.first(where: {$0.endTime == -1}) else { return nil }
        return node
    }
    
    fileprivate func finishRunningTracker() {
        if let tracker = self.findRunningTracker() {
            self.finishRunningNode(tracker)
            self.saveTracker(tracker)
        }
    }
    
    fileprivate func finishRunningNode(_ tracker: TimeTracker) {
        guard let node = self.findRunningNode(tracker) else { return }
        node.endTime = Date.init().timeIntervalSince1970
    }
    
    fileprivate func createOrRecoverTracker(_ issue: Issue) -> TimeTracker {
        #if DEBUG
        if CREATE_FAKE_TRACKERS {
            let tracker = TimeTracker.init()
            tracker.issue = issue
            tracker.fileName = "\(UUID.init().uuidString).tracker"
            tracker.timeNodes = (1...10).map({ i  -> TimeNode in
                let node = TimeNode.init()
                node.startTime = Date.init().timeIntervalSince1970 + TimeInterval(i).day
                node.endTime += node.startTime + 1.hour
                return node
            })
            return tracker
        }
        #endif
        guard let issueTracker = self.currentTimeTrackers.first(where: {$0.issue?.id == issue.id}) else {
            let tracker = TimeTracker.init()
            tracker.fileName = "\(UUID.init().uuidString).tracker"
            tracker.issue = issue
            return tracker
        }
        return issueTracker
    }
 
    @discardableResult
    fileprivate func createTimeNode(_ tracker: TimeTracker) -> TimeNode {
        var nodes = tracker.timeNodes ?? []
        let node = TimeNode.init()
        node.startTime = Date.init().timeIntervalSince1970
        nodes.append(node)
        tracker.timeNodes = nodes
        return node
    }
    
    fileprivate func saveAndAddTracker(_ tracker: TimeTracker) {
        if self.saveTracker(tracker) {
            if !self.currentTimeTrackers.contains(tracker) {
                self.currentTimeTrackers.insert(tracker, at: 0)
            }
        }
    }
    
    @discardableResult
    fileprivate func saveTracker(_ tracker: TimeTracker) -> Bool {
        let filePath = self.trackersPath + tracker.fileName!
        let writer = JsonWriter.init()
        guard let jsonString: String = writer.write(anyObject: tracker) else { return false }
        do {
            try jsonString.write(toFile: filePath.description, atomically: true, encoding: .utf8)
            return true
        } catch let error {
            print(#function)
            print(error)
        }
        return false
    }
}
