//
//  TimeHistoryDetailViewController.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 16/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class TimeHistoryDetailViewController: UITableViewController {
    fileprivate weak var dataSource: DataSource<TimeNode>!
    fileprivate var delegateDataSource: GenericDelegateDataSource!
    
    weak var timeTracker: TimeTracker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func createDataSources() {
        let dataSource = DataSource.init()
        dataSource.items = self.timeTracker?.timeNodes ?? []
        
        let sections = [
        self.delegateDataSource = GenericDelegateDataSource.init(withSections: <#T##[SectionProtocol]#>, andTableView: <#T##UITableView#>)
    }
}
