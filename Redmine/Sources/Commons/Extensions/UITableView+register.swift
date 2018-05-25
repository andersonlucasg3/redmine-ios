//
//  UITableView+register.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 24/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit.UITableView

extension UITableView {
    func register(cellClass: UITableViewCell.Type) {
        self.register(UINib.init(nibName: cellClass.className, bundle: Bundle.main),
                      forCellReuseIdentifier: cellClass.reusableIdentifier)
    }
}
