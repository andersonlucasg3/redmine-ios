//
//  DurationHelper.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

struct DurationHelper {
    fileprivate static func getFormatedDatePart(_ value: Int) -> String {
        return value >= 10 ? "\(value)" : "0\(value)"
    }
    
    static func formattedTime(for duration: TimeInterval) -> String {
        let hours = Int(duration / 60.minutes)
        let minutes = Int((duration / 60.seconds).truncatingRemainder(dividingBy: 60))
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60.seconds))
        let hourString = self.getFormatedDatePart(hours)
        let minuteString = self.getFormatedDatePart(minutes)
        let secondString = self.getFormatedDatePart(seconds)
        return "\(hourString):\(minuteString):\(secondString)"
    }
}
