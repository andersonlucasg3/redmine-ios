//
//  LoadMoreSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 04/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class LoadMoreSection: Section {
    required init(title: String? = nil, footer: String? = nil, dataSource: DataSourceProtocol) {
        super.init(title: title, footer: footer, dataSource: dataSource)
    }
    
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return LoadMoreCell.self
    }
}
