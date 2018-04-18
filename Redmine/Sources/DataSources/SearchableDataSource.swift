//
//  SearchableDataSource.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import GenericDataSourceSwift

protocol Searchable {
    var searchableValues: [String] { get }
}

class SearchableDataSource<DataType: Searchable>: DataSource<DataType> {
    fileprivate var originalItems: [DataType]!
    
    fileprivate override init() {
        super.init()
    }
    
    init(_ items: [DataType]) {
        super.init()
        self.items = items
        self.originalItems = items
    }
    
    fileprivate func doesItemContainsQuery(_ item: String, _ query: String) -> Bool {
        return item.contains(query)
    }
    
    fileprivate func anyItemContainsQuery(_ items: [String], _ query: String) -> Bool {
        for item in items {
            if self.doesItemContainsQuery(item, query) {
                return true
            }
        }
        return false
    }
    
    func isQueryValid(_ query: String, for item: DataType) -> Bool {
        let lowerQuery = query.lowercased()
        let loweredItems = item.searchableValues.map({$0.lowercased()})
        return lowerQuery == "" || self.anyItemContainsQuery(loweredItems, lowerQuery)
    }
    
    func performSearch(_ query: String?) {
        if let query = query, query.count > 0 {
            self.items = self.originalItems.filter({ [unowned self] in self.isQueryValid(query, for: $0) })
        } else {
            self.items = self.originalItems
        }
    }
}
