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

class TimeTrackerController {
    fileprivate let trackersPath = Path.userCaches + "trackers"
    fileprivate(set) var currentTimeTrackers: [TimeTracker]!
    
    init() {
        self.currentTimeTrackers = self.loadFiles()
    }
    
    fileprivate func loadFiles() -> [TimeTracker] {
        let filteredChildren: [Path] = self.trackersPath.children().filter({ (item: Path) in
            let regular = item.isRegular
            let isDotFile = item.fileName.starts(with: ".")
            return regular && !isDotFile
        })
        return filteredChildren.compactMap({ item in
            let jsonString = try? String(contentsOfPath: item)
            return ApiResultProcessor.processResult(content: jsonString)
        })
    }
    
    func addNewTracker(for issue: Issue) -> TimeTracker {
        // TODO: Elaborar melhor o algorítmo para saber o dia que o TimeNode foi criado para poder associar a data certa no redmine.
        // Exemplo, comecei uma tarefa hoje. Tenho 2 time nodes criados, antes do almoço e depois do almoço.
        // Aí retorno no dia seguinte e continuo na mesma tarefa.
        // Quando for finalizar o time tracker deverá ser criado para 2 dias diferentes para que não entrem 16 horas no mesmo dia no redmine.
        let tracker = self.createTracker(issue)
        self.addTracker(tracker)
        return tracker
    }
    
    func remove(tracker: TimeTracker) {
        let filePath = self.trackersPath + tracker.fileName!
        try! filePath.deleteFile()
        if let index = self.currentTimeTrackers.index(of: tracker) {
            self.currentTimeTrackers.remove(at: index)
        }
    }
    
    fileprivate func createTracker(_ issue: Issue) -> TimeTracker {
        let tracker = TimeTracker.init()
        let node = TimeNode.init()
        node.startTime = Date.init().timeIntervalSince1970
        tracker.timeNodes = [node]
        
        tracker.fileName = "\(UUID.init().uuidString).tracker"
        tracker.issue = issue
        return tracker
    }
    
    fileprivate func addTracker(_ tracker: TimeTracker) {
        let filePath = self.trackersPath + tracker.fileName!
        let writer = JsonWriter.init()
        guard let jsonString: String = writer.write(anyObject: tracker) else { return }
        do {
            try jsonString.write(to: filePath)
            self.currentTimeTrackers.append(tracker)
        } catch let error {
            print(#function)
            print(error)
        }
    }
}
