//
//  ProjectTableViewCell.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import GenericDataSourceSwift

protocol ProjectTableViewCellProtocol: class {
    func didTapOpenIssuesButton(in cell: ProjectTableViewCell)
}

class ProjectTableViewCell: UITableViewCell, Setupable {
    typealias DataType = Project
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var projectInfoButton: UIButton!
    @IBOutlet weak var openIssuesButton: UIButton!
    
    weak var delegate: ProjectTableViewCellProtocol?
    
    func setup(with data: Project) {
        self.titleLabel.text = data.name
        self.subtitleLabel.text = data.subtitle
    }
    
    @IBAction fileprivate func openIssuesButton(sender: UIButton) {
        self.delegate?.didTapOpenIssuesButton(in: self)
    }
}
