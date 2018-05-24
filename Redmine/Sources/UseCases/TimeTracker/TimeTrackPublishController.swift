//
//  TimeTrackPublishController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 22/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import Swift_Json

protocol TimeTrackPublishControllerProtocol: class {
    func timeTrackPublish(_ publisher: TimeTrackPublishController, didFailToPublishNodesWithError error: Error)
    func timeTrackPublish(_ publisher: TimeTrackPublishController, didPublishNodes nodes: [TimeNode])
    func timeTrackPublishingAllNodes(_ publisher: TimeTrackPublishController)
}

class TimeTrackPublishController: RequestProtocol {
    fileprivate let session: SessionController
    fileprivate var request: Request!
    fileprivate var itemsToPublish: [TimeEntry: [TimeNode]]
    
    weak var delegate: TimeTrackPublishControllerProtocol?
    
    init(timeEntries: [TimeEntry: [TimeNode]], and session: SessionController) {
        self.session = session
        self.itemsToPublish = timeEntries
    }
    
    func start() {
        self.startOrFinish()
    }
    
    fileprivate func hasTimeEntryToPublish() -> Bool {
        return self.itemsToPublish.count > 0
    }
    
    fileprivate func startOrFinish() {
        if self.hasTimeEntryToPublish() {
            self.publish()
        } else {
            self.dispatchFinished()
        }
    }
    
    fileprivate func publish() {
        let timeEntry = self.itemsToPublish.first!.key
        let timeEntryBody = TimeEntryBottle.init()
        timeEntryBody.timeEntry = timeEntry
        
        let writer = JsonWriter.init()
        let config = JsonConfig.init(SnakeCaseConverter.init())
        config.shouldIncludeNullValueKeys = false
        let jsonString: String = writer.write(anyObject: timeEntryBody, withConfig: config)!
        
        print(jsonString)
        
        self.request = Request.init(url: Ambients.getTimeEntriesPath(with: self.session), method: .post)
        self.request.addHeader(for: "X-Redmine-API-Key", with: self.session.user?.apiKey ?? "")
        self.request.addHeader(for: "Content-Type", with: "application/json")
        self.request.bodyType = .json
        self.request.bodyContent = jsonString.data(using: .utf8)
        self.request.delegate = self
        self.request.start()
    }
    
    fileprivate func dispatchPartialCompletion(_ nodes: [TimeNode]) {
        self.delegate?.timeTrackPublish(self, didPublishNodes: nodes)
    }
    
    fileprivate func dispatchFinished() {
        self.delegate?.timeTrackPublishingAllNodes(self)
    }
    
    fileprivate func dispatchFail(_ error: Error) {
        self.delegate?.timeTrackPublish(self, didFailToPublishNodesWithError: error)
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didReceiveResponse response: HTTPURLResponse?) {
        guard let urlResponse = response, urlResponse.statusCode == 201 else {
            return
        }
        
        let removedNodes = self.itemsToPublish.removeValue(forKey: self.itemsToPublish.first!.key)!
        self.dispatchPartialCompletion(removedNodes)
        
        self.startOrFinish()
    }
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        print(content ?? "TimeTrackPublishing returned no content!")
    }
    
    func request(_ request: Request, didFailWithError error: Error) {
        self.dispatchFail(error)
    }
}
