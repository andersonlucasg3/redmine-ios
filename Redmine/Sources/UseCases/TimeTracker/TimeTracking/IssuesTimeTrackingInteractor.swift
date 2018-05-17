//
//  IssuesTimeTrackingInteractor.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 12/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class IssuesTimeTrackingInteractor: IssuesSectionProtocol {
    weak var viewController: (UIViewController&RefreshableTableViewProtocol)?
    weak var timeTrackerController: TimeTrackerController?
    
    init(viewController: UIViewController&RefreshableTableViewProtocol, timeTrackerController: TimeTrackerController) {
        self.viewController = viewController
        self.timeTrackerController = timeTrackerController
    }
    
    fileprivate func goToTrackingTab() {
        self.viewController?.tabBarController?.selectedIndex = 0 // go to trackers view controller
    }
    
    fileprivate func startTrackingTimeAndGoToScreen(_ issue: Issue) {
        self.timeTrackerController?.startTracker(for: issue)
        self.viewController?.reloadTableView()
        self.goToTrackingTab()
    }
    
    fileprivate func presentAlreadyRunningTrackerAlert(_ tracker: TimeTracker, _ issue: Issue) {
        _ = self.viewController?.showAlert(withTitle: "Redmine", message: "There is still a running timer for issue \"\(tracker.issue?.name ?? "Unknown")\". It will be paused to start the selected one. Ok?",
            cancelAction: (title: "Cancel", action: {}),
            confirmAction: (title: "Procceed", action: { [unowned self] in
                self.startTrackingTimeAndGoToScreen(issue)
            }))
    }
    
    fileprivate func presentSameIssueRunningTrackerAlert() {
        _ = self.viewController?.showAlert(withTitle: "Redmine", message: "The Issue you selected have already a running tracker for it. You will be redirected to the Time Tracking Tab.",
                       confirmAction: (title: "Go", action: { [unowned self] in
                        self.goToTrackingTab()
                       }))
    }
    
    // MARK: IssuesSectionProtocol
    
    func startTrackingTime(for issue: Issue) {
        if let running = self.timeTrackerController?.runningTracker {
            if issue.id == running.issue?.id {
                self.presentSameIssueRunningTrackerAlert()
            } else {
                self.presentAlreadyRunningTrackerAlert(running, issue)
            }
        } else {
            self.startTrackingTimeAndGoToScreen(issue)
        }
    }
}
