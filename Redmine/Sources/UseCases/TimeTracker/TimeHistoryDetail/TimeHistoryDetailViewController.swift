//
//  TimeHistoryDetailViewController.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 16/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class TimeHistoryDetailViewController: UITableViewController {
    fileprivate let processor = TimeHistoryProcessor.init()
    fileprivate var delegateDataSource: GenericDelegateDataSource!
    
    weak var timeTracker: TimeTracker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerHeaders()
        self.createDataSources()
    }
    
    fileprivate func registerHeaders() {
        let className = TimeHistoryDetailHeader.className
        let nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.tableView.register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    fileprivate func dayId(for date: Date) -> Int {
        return Calendar.current.component(.day, from: date)
    }
    
    fileprivate func filterTimeNodes() -> [String: [TimeNode]] {
        guard let tracker = self.timeTracker else { return [:] }
        return self.processor.filterTimeNodes(for: tracker)
    }
    
    fileprivate func createDataSources() {
        let groupedTimeNodes = self.filterTimeNodes()
    
        let sections: [TimeHistoryDetailSection] = groupedTimeNodes.map { (key: String, nodes: [TimeNode]) -> TimeHistoryDetailSection in
            let dataSource = DataSource<TimeNode>.init()
            dataSource.items = nodes
            return TimeHistoryDetailSection.init(with: key, dataSource: dataSource)
        }
        self.delegateDataSource = GenericDelegateDataSource.init(withSections: sections, andTableView: self.tableView)
        self.tableView.delegate = self.delegateDataSource
        self.tableView.dataSource = self.delegateDataSource
    }
}
