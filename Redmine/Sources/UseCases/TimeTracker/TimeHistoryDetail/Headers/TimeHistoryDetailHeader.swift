//
//  TimeHistoryDetailHeader.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class TimeHistoryDetailHeader: UITableViewHeaderFooterView, Setupable {
    typealias DataType = String
    
    @IBOutlet fileprivate weak var dayLabel: UILabel!
    
    func setup(with data: String) {
        self.dayLabel.text = data
    }
}
