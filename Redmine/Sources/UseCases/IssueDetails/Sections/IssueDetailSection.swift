//
//  IssueDetailSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class IssueDetailSection: Section {
    var index: Int = 0
    
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return IssueDetailTableViewCell.self
    }
    
    override func cellPostConfiguration(for cell: UITableViewCell, at indexPath: IndexPath) {
        (cell as? IssueDetailTableViewCell)?.lineView.isHidden = indexPath.row == (self.itemCount() - 1)
    }
    
    override func headerHeight() -> CGFloat? {
        return (self.index > 0 && self.itemCount() > 0) ? 40 : nil
    }
}
