//
//  SearchableDataSource.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

class SearchableDataSource<DataType>: DataSource<DataType> {
    fileprivate var originalItems: [DataType]!
    
    fileprivate override init() {
        super.init()
    }
    
    init(_ items: [DataType]) {
        super.init()
        self.items = items
        self.originalItems = items
    }
    
    func isQueryValid(_ query: String, for item: DataType) -> Bool {
        return true
    }
    
    func performSearch(_ query: String?) {
        if let query = query, query.count > 0 {
            self.items = self.originalItems.filter({ [unowned self] in self.isQueryValid(query, for: $0) })
        } else {
            self.items = self.originalItems
        }
    }
}
