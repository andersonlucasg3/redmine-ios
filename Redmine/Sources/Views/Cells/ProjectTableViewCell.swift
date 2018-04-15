//
//  ProjectTableViewCell.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

class ProjectTableViewCell: UITableViewCell, Setupable {
    typealias DataType = Project
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    
    func setup(with data: Project) {
        self.titleLabel.text = data.name
        self.subtitleLabel.text = data.subtitle
    }
}
