//
//  IssuesSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class IssuesSection: Section {
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return IssueTableViewCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 120
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 120
    }
}
