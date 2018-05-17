//
//  TimeTrackingTableViewCell.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 12/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit.UITableViewCell
import GenericDataSourceSwift

class TimeTrackingTableViewCell: UITableViewCell, Setupable {
    typealias DataType = TimeTracker
    
    @IBOutlet fileprivate weak var issueNameLabel: UILabel!
    @IBOutlet fileprivate weak var timeLabel: UILabel!
    @IBOutlet fileprivate weak var projectNameLabel: UILabel!
    @IBOutlet fileprivate(set) weak var playPauseButton: UIButton!
    @IBOutlet fileprivate(set) weak var publishButton: UIButton!
    
    fileprivate var timer: Timer!
    fileprivate weak var timeTracker: TimeTracker!
    
    deinit {
        self.stopTimer()
    }
    
    func setup(with data: TimeTracker) {
        self.timeTracker = data
        
        self.issueNameLabel.text = data.issue?.name
        self.projectNameLabel.text = data.issue?.project?.name
        self.updateTimeLabel()
        
        self.startTimer()
    }
    
    func startTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                              selector: #selector(self.secondTimerFire(_:)),
                                              userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    fileprivate func updateTimeLabel() {
        if let timeTracker = self.timeTracker {
            self.timeLabel.text = DurationHelper.formattedTime(for: timeTracker.duration())
        } else {
            self.stopTimer()
        }
    }
    
    @objc fileprivate func secondTimerFire(_ timer: Timer) {
        self.updateTimeLabel()
    }
}
