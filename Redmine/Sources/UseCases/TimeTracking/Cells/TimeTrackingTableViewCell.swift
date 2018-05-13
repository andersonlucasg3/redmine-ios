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
    
    func setup(with data: TimeTracker) {
        self.issueNameLabel.text = data.issue?.name
        self.timeLabel.text = self.formattedTime(from: data.duration())
        self.projectNameLabel.text = data.issue?.project?.name
    }
    
    fileprivate func formattedTime(from duration: TimeInterval) -> String {
        let hours = Int(duration / 60.minutes)
        let minutes = Int((duration / 60.seconds).truncatingRemainder(dividingBy: 60))
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60.seconds))
        return "\(hours):\(minutes):\(seconds)"
    }
}
