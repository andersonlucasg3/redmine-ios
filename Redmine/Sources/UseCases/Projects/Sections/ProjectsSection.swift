//
//  ProjectsSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import GenericDataSourceSwift

protocol ProjectsSectionProtocol: class {
    func openProjectInfo(for project: Project)
    func openIssues(for project: Project)
}

class ProjectsSection: Section, ProjectTableViewCellProtocol {
    weak var delegate: ProjectsSectionProtocol?
    
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return ProjectTableViewCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 88
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 88
    }
    
    func cellPostConfiguration(for cell: UITableViewCell, at indexPath: IndexPath) {
        let projectCell = cell as! ProjectTableViewCell
        projectCell.tag = indexPath.row
        projectCell.delegate = self
        projectCell.configureBackground(at: indexPath)
    }
    
    // MARK: ProjectTableViewCellProtocol
    
    func didTapProjectInfoButton(in cell: ProjectTableViewCell) {
        self.delegate?.openProjectInfo(for: self.getItem(for: cell.tag))
    }
    
    func didTapOpenIssuesButton(in cell: ProjectTableViewCell) {
        self.delegate?.openIssues(for: self.getItem(for: cell.tag))
    }
}
