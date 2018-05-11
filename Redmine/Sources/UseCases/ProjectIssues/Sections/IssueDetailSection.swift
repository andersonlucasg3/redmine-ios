//
//  IssueDetailSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class IssueDetailSection: Section {
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return IssueDetailTableViewCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 32
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 32
    }
    
    func cellPostConfiguration(for cell: UITableViewCell, at indexPath: IndexPath) {
        (cell as? IssueDetailTableViewCell)?.lineView.isHidden = indexPath.row == (self.itemCount() - 1)
    }
}
