//
//  TimeHistoryDetailSection.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 16/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class TimeHistoryDetailSection: Section {
    init(with sectionObject: String, dataSource: DataSourceProtocol) {
        super.init(dataSource: dataSource)
        self.headerObject = sectionObject
    }
    
    required init(title: String?, footer: String?, dataSource: DataSourceProtocol) {
        super.init(title: title, footer: footer, dataSource: dataSource)
    }
    
    // MARK: Cell configuration
    
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return TimeHistoryDetailCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 44
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 44
    }
    
    func cellPostConfiguration(for cell: UITableViewCell, at indexPath: IndexPath) {
        cell.configureBackground(at: indexPath)
    }
    
    // MARK: Header configuration
    
    func headerType() -> UITableViewHeaderFooterView.Type {
        return TimeHistoryDetailHeader.self
    }
    
    func headerHeight() -> CGFloat {
        return 44
    }
}
