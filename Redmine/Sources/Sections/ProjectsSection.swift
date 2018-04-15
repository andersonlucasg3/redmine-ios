//
//  ProjectsSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import GenericDataSourceSwift

class ProjectsSection: Section {
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return ProjectTableViewCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 88
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 88
    }
}
