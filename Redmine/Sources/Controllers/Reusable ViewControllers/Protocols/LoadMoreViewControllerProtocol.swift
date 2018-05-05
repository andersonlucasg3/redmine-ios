//
//  LoadMoreViewControllerProtocol.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 04/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

protocol LoadMoreViewControllerProtocol: class {
    var pageCounter: PageCounterController? { get set }
}

extension LoadMoreViewControllerProtocol where Self : RefreshableTableViewController {
    func setupPageCounterIfNeeded(totalItems: Int) {
        if self.pageCounter == nil {
            self.pageCounter = PageCounterController(itemsPerPage: ITEMS_PER_PAGE, total: totalItems)
        }
    }
    
    func loadNextPage() {
        self.pageCounter?.nextPage()
        self.startRefreshing()
    }
}
