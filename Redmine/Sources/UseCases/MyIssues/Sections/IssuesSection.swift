//
//  IssuesSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

protocol IssuesSectionProtocol: class {
    func startTrackingTime(for issue: Issue)
}

class IssuesSection: Section {
    weak var delegate: IssuesSectionProtocol?
    
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return IssueTableViewCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 120
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 120
    }
    
    func cellPostConfiguration(for cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? IssueTableViewCell else { return }
        cell.timeTrackerButton.tag = indexPath.row
        if cell.timeTrackerButton.actions(forTarget: self, forControlEvent: .touchUpInside) == nil {
            cell.timeTrackerButton.addTarget(self, action: #selector(self.timeTrackerButton(sender:)), for: .touchUpInside)
        }
    }
    
    @objc fileprivate func timeTrackerButton(sender: UIButton) {
        let index = sender.tag
        self.delegate?.startTrackingTime(for: self.getItem(for: index))
    }
}
