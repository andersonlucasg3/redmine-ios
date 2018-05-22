//
//  TimePublisher.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 22/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation



class TimePublisher: RequestProtocol {
    fileprivate let session: SessionController
    
    fileprivate var request: Request!
    
    fileprivate var itemsToPublish: [TimeEntry]
    
    init(timeEntries: [TimeEntry], and session: SessionController) {
        self.session = session
        self.itemsToPublish = timeEntries
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
        
        self.request = Request.init(url: Ambients.getTimeEntriesPath(with: self.session), method: .post)
        self.request.addHeader(for: "X-Redmine-API-Key", with: self.session.user?.apiKey ?? "")
        self.request.start()
    }
    
    fileprivate func dispatchFinished() {
        
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didReceiveResponse response: HTTPURLResponse?) {
        guard let urlResponse = response, urlResponse.statusCode == 200 else {
            self.request(request, didFailWithError: RequestError.statusCode(code: response?.statusCode ?? 0, content: nil))
            return
        }
        
        self.itemsToPublish.removeFirst()
        
        self.startOrFinish()
    }
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        
    }
    
    func request(_ request: Request, didFailWithError error: Error) {
        self.startOrFinish()
    }
}
