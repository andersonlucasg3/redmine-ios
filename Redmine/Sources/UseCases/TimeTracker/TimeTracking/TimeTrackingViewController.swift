//
//  TimeTrackingViewController.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 11/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import SwiftyTimer
import GenericDataSourceSwift

class TimeTrackingViewController: UITableViewController, TimeTrackingTableViewCellProtocol, GenericDelegateDataSourceProtocol {
    fileprivate let sessionController = SessionController.init()
    fileprivate lazy var timeTrackerController = TimeTrackerController.init(with: self.sessionController)
    
    fileprivate weak var dataSource: DataSource<TimeTracker>!
    fileprivate var genericDataSource: GenericDelegateDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateDataSource()
        self.startMinuteTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.updateDataSource()
        self.stopMinuteTimer()
    }
    
    fileprivate func createDataSource() {
        let dataSource = DataSource<TimeTracker>.init()
        dataSource.items = self.timeTrackerController.currentTimeTrackers
        let sections: [TimeTrackingSection] = [TimeTrackingSection.init(dataSource: dataSource)]
        sections.forEach({$0.delegate = self})
        self.genericDataSource = GenericDelegateDataSource.init(withSections: sections, andTableView: self.tableView)
        self.tableView.delegate = self.genericDataSource
        self.tableView.dataSource = self.genericDataSource
        self.genericDataSource.delegate = self
        
        self.dataSource = dataSource
    }
    
    fileprivate func updateDataSource() {
        self.dataSource.items = self.timeTrackerController.currentTimeTrackers
        self.reloadTableView()
    }
    
    fileprivate func reloadTableView() {
        self.tableView.reloadData()
    }
    
    fileprivate func startMinuteTimer() {
        self.tableView.visibleCells.compactMap({$0 as? TimeTrackingTableViewCell}).forEach { (cell) in
            cell.startTimer()
        }
    }
    
    fileprivate func stopMinuteTimer() {
        self.tableView.visibleCells.compactMap({$0 as? TimeTrackingTableViewCell}).forEach { (cell) in
            cell.stopTimer()
        }
    }
    
    @objc fileprivate func minuteTimerFire(_ timer: Timer) {
        self.reloadTableView()
    }
    
    fileprivate func showCurrentTrackingWillBePausedToBeginOther(_ tracker: TimeTracker, _ runningTracker: TimeTracker) {
        self.showAlert(withTitle: "Redmine",
                       message: "The tracker \"\(runningTracker.issue?.name ?? "Unknown")\" will be stopped to start \"\(tracker.issue?.name ?? "Unknown")\"",
                       confirmAction: (title: "Ok", action: { [unowned self] in
                            self.timeTrackerController.pauseTracker(runningTracker)
                            self.timeTrackerController.continueTracker(tracker)
                            self.updateDataSource()
                       }))
    }
    
    // MARK: TimeTrackingTableViewCellProtocol
    
    func playPauseAction(for tracker: TimeTracker, finishAction callThis: ((PlayPauseAction) -> Void)) {
        if let runningTracker = self.timeTrackerController.runningTracker {
            if runningTracker == tracker {
                self.timeTrackerController.pauseTracker(tracker)
                callThis(.pause)
            } else {
                callThis(.pause)
                self.showCurrentTrackingWillBePausedToBeginOther(tracker, runningTracker)
            }
        } else {
            self.timeTrackerController.continueTracker(tracker)
            callThis(.play)
        }
        self.updateDataSource()
    }
    
    func publishAction(for tracker: TimeTracker) {
        
    }
    
    func state(for item: TimeTracker) -> PlayPauseAction {
        return self.timeTrackerController.runningTracker == item ? .pause : .play
    }
    
    // MARK: GenericDelegateDataSourceProtocol
    
    func didSelectItem(at indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let item: TimeTracker = self.dataSource.getItem(for: indexPath.row)
        
        let controller = TimeHistoryDetailViewController.instantiate()!
        controller.timeTracker = item
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
