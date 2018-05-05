//
//  BasicResult.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class BasicResult: NSObject {
    @objc var totalCount: Int = 0
    @objc var offset: Int = 0
    @objc var limit: Int = 0
    
    func append(from obj: BasicResult) {
        self.totalCount = obj.totalCount
        self.offset = obj.offset
        self.limit = obj.limit
    }
}
