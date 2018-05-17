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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dateFormatter.dateFormat = "dd/MM HH:mm:ss"
    }
    
    func setup(with data: TimeNode) {
        self.set(timeInterval: data.startTime, into: self.startTimeLabel)
        self.set(timeInterval: data.endTime, into: self.endTimeLabel)
        self.set(duration: data.duration(), into: self.durationLabel)
    }
    
    fileprivate func set(timeInterval: TimeInterval, into label: UILabel) {
        label.text = self.dateFormatter.string(from: Date.init(timeIntervalSince1970: timeInterval))
    }
    
    fileprivate func set(duration: TimeInterval, into label: UILabel) {
        label.text = DurationHelper.formattedTime(for: duration)
    }
}
