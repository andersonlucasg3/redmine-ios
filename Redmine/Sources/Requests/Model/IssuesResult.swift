//
//  IssuesResult.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class IssuesResult: BasicResult {
    @objc var issues: [Issue]?
    
    func append(from obj: IssuesResult) {
        super.append(from: obj)
        self.issues?.append(contentsOf: obj.issues ?? [])
    }
}
