//
//  TimeHistoryPublishIteractor.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 22/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import PKHUD

protocol TimeHistoryPublishIteractorProtocol: class {
    func timeEntryPublished(of tracker: TimeTracker)
}

class TimeHistoryPublishIteractor: TimeHistoryDetailIteractor, TimeTrackPublishControllerProtocol {
    fileprivate let sessionController = SessionController.init()
    
    fileprivate var publishController: TimeTrackPublishController!
    
    weak var delegate: TimeHistoryPublishIteractorProtocol?
    
    override func updateData() {
        HUD.show(.progress)
        
        let filtered = self.processor.filterTimeNodesForPublishing(from: self.timeTracker, of: self.sessionController.user!)
        self.publishController = TimeTrackPublishController.init(timeEntries: filtered,
                                                                 and: self.sessionController)
        self.publishController.delegate = self
        self.publishController.start()
    }
    
    // MARK: TimeTrackPublishControllerProtocol
    
    func timeTrackPublish(_ publisher: TimeTrackPublishController, didPublishNodes nodes: [TimeNode]) {
        self.timeTracker.timeNodes = Array(Set(self.timeTracker.timeNodes ?? []).subtracting(nodes))
        self.createDataSources()
        self.setTotalDuration()
        super.updateData()
    }
    
    func timeTrackPublishingAllNodes(_ publisher: TimeTrackPublishController) {
        HUD.flash(.success, delay: 1.0)
        self.delegate?.timeEntryPublished(of: self.timeTracker)
        self.viewController.navigationController?.popViewController(animated: true)
    }
    
    func timeTrackPublish(_ publisher: TimeTrackPublishController, didFailToPublishNodesWithError error: Error) {
        print(error)
        HUD.flash(.labeledError(title: "Redmine", subtitle: "Failed to publish time entry."), delay: 1.0)
        self.viewController.navigationController?.popViewController(animated: true)
    }
}
