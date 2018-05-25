//
//  UITableView+reloadDataAnimated.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 24/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

extension UITableView {
    func animateRemoveItem(at indexPath: IndexPath, dataSourceUpdateBlock block: os_block_t) {
        self.beginUpdates()
        block()
        self.deleteRows(at: [indexPath], with: .automatic)
        self.endUpdates()
    }
}
