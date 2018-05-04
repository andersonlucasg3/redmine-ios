//
//  ProfileSection.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 03/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import GenericDataSourceSwift

protocol ProfileSectionProtocol: class {
    func logoutUser()
}

class ProfileSection: Section {
    weak var delegate: ProfileSectionProtocol?
    
    override func cellType(for index: Int) -> UITableViewCell.Type {
        return LogoutCell.self
    }
    
    override func cellHeight(for index: Int) -> CGFloat {
        return 44
    }
    
    override func estimatedCellHeight(for index: Int) -> CGFloat {
        return 44
    }
}
