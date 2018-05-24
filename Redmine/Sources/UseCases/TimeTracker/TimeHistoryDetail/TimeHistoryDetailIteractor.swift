//
//  TimeHistoryDetailInteractor.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 22/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class TimeHistoryDetailIteractor {
    fileprivate var delegateDataSource: GenericDelegateDataSource!
    
    let processor = TimeHistoryProcessor.init()
    
    weak var viewController: TimeHistoryDetailViewController!
    weak var tableView: UITableView!
    weak var timeTracker: TimeTracker!
    weak var totalDurationLabel: UILabel!
    
    func registerHeaders() {
        let className = TimeHistoryDetailHeader.className
        let nib = UINib.init(nibName: className, bundle: Bundle.main)
        self.tableView?.register(nib, forHeaderFooterViewReuseIdentifier: className)
    }
    
    func filterTimeNodes() -> [String: [TimeNode]] {
        guard let tracker = self.timeTracker else { return [:] }
        return self.processor.filterTimeNodes(for: tracker)
    }
    
    func createDataSources() {
        let groupedTimeNodes = self.filterTimeNodes()
        
        let sections: [TimeHistoryDetailSection] = groupedTimeNodes.map { (key: String, nodes: [TimeNode]) -> TimeHistoryDetailSection in
            let dataSource = DataSource<TimeNode>.init()
            dataSource.items = nodes
            return TimeHistoryDetailSection.init(with: key, dataSource: dataSource)
        }
        self.delegateDataSource = GenericDelegateDataSource.init(withSections: sections, andTableView: self.tableView)
        self.tableView?.delegate = self.delegateDataSource
        self.tableView?.dataSource = self.delegateDataSource
    }
    
    func setTotalDuration() {
        self.totalDurationLabel?.text = DurationHelper.formattedTime(for: self.timeTracker?.duration() ?? 0.0)
    }
    
    func updateData() {
        self.tableView?.reloadData()
    }
}
