//
//  Basic.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

@objc(Basic)
class Basic: NSObject, Searchable {
    @objc var id: Int = 0
    @objc var name: String?
    
    var searchableValues: [String] {
        return ["\(self.id)", self.name ?? ""]
    }
}
