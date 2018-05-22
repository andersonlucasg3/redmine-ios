//
//  TimeHistoryDetailViewController.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 16/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class TimeHistoryDetailViewController: UITableViewController {
    @IBOutlet fileprivate weak var totalDurationLabel: UILabel!
    
    var iteractor: TimeHistoryDetailIteractor!
    weak var timeTracker: TimeTracker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createIteractor()
        
        self.iteractor.registerHeaders()
        self.iteractor.createDataSources()
        self.iteractor.setTotalDuration()
        self.iteractor.updateData()
    }
    
    fileprivate func createIteractor() {
        self.iteractor = TimeHistoryDetailIteractor.init()
        self.iteractor.tableView = self.tableView
        self.iteractor.timeTracker = self.timeTracker
        self.iteractor.totalDurationLabel = self.totalDurationLabel
    }
}
