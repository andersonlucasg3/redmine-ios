//
//  UITableView+reloadDataAnimated.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 24/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

extension UITableView {
    fileprivate func commonUpdates(_ indexPath: IndexPath, _ tvUpdateBlock: os_block_t, _ dtUpdateBlock: os_block_t) {
        self.beginUpdates()
        dtUpdateBlock()
        tvUpdateBlock()
        self.endUpdates()
    }
    
    func animateRemoveItem(at indexPath: IndexPath, dataSourceUpdateBlock block: os_block_t) {
        self.commonUpdates(indexPath, { [unowned self] in
            self.deleteRows(at: [indexPath], with: .automatic)
        }, block)
    }
    
    func animateInsertItem(at indexPath: IndexPath, dataSourceUpdateBlock block: os_block_t) {
        self.commonUpdates(indexPath, { [unowned self] in
            self.insertRows(at: [indexPath], with: .automatic)
        }, block)
    }
}
