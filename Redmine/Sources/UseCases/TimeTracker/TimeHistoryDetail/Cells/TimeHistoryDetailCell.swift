//
//  TimeHistoryDetailCell.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class TimeHistoryDetailCell: UITableViewCell, Setupable {
    typealias DataType = TimeNode
    
    @IBOutlet fileprivate weak var startTimeLabel: UILabel!
    @IBOutlet fileprivate weak var endTimeLabel: UILabel!
    @IBOutlet fileprivate weak var durationLabel: UILabel!
    
    fileprivate let dateFormatter = DateFormatter.init()
    fileprivate var timer: Timer!
    fileprivate weak var timeNode: TimeNode?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateFormatter.dateFormat = "dd/MM HH:mm:ss"
    }
    
    deinit {
        self.stopTimer()
    }
    
    func setup(with data: TimeNode) {
        self.timeNode = data
        self.updateLabels()
        self.startTimerIfNeeded()
    }
    
    fileprivate func updateLabels() {
        guard let node = self.timeNode else { return }
        let nowTimeInterval = Date().timeIntervalSince1970
        self.set(timeInterval: node.startTime, into: self.startTimeLabel)
        self.set(timeInterval: node.endTime == -1 ? nowTimeInterval : node.endTime, into: self.endTimeLabel)
        self.set(duration: node.duration(), into: self.durationLabel)
    }
    
    fileprivate func startTimerIfNeeded() {
        if self.timeNode?.endTime == -1, case nil = self.timer {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerTick(timer:)), userInfo: nil, repeats: true)
        } else {
            self.stopTimer()
        }
    }
    
    fileprivate func stopTimer() {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc fileprivate func timerTick(timer: Timer) {
        self.updateLabels()
    }
    
    fileprivate func set(timeInterval: TimeInterval, into label: UILabel) {
        label.text = self.dateFormatter.string(from: Date.init(timeIntervalSince1970: timeInterval))
    }
    
    fileprivate func set(duration: TimeInterval, into label: UILabel) {
        label.text = DurationHelper.formattedTime(for: duration)
    }
}
