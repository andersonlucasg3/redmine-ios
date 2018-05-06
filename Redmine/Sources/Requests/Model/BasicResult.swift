//
//  BasicResult.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

protocol SpecificResultProtocol: class {
    associatedtype SpecificResult : Searchable
    
    var results: [SpecificResult]? { get set }
}

extension SpecificResultProtocol where Self : BasicResult {
    func append(from obj: Self) {
        self.update(from: obj)
        self.results?.append(contentsOf: obj.results ?? [])
    }
}

class BasicResult: NSObject {
    @objc var totalCount: Int = 0
    @objc var offset: Int = 0
    @objc var limit: Int = 0
    
    override required init() { }
    
    func update(from obj: BasicResult) {
        self.totalCount = obj.totalCount
        self.offset = obj.offset
        self.limit = obj.limit
    }
}
