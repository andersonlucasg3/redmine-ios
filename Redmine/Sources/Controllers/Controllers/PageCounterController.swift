//
//  PageCounterController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 04/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class PageCounterController {
    fileprivate(set) var currentPage: Int = 0
    
    fileprivate var itemsPerPage: Int
    fileprivate(set) var totalItems: Int
    
    var hasNextPage: Bool {
        return self.canGoNextPage()
    }
    
    init(itemsPerPage: Int, total: Int) {
        self.itemsPerPage = itemsPerPage
        self.totalItems = total
    }
    
    func nextPage() {
        if self.canGoNextPage() {
            self.currentPage += 1
        }
    }
    
    fileprivate func canGoNextPage() -> Bool {
        return (self.currentPage + 1) * self.itemsPerPage < self.totalItems
    }
}
