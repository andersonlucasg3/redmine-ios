//
//  IssuesResult.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class IssuesResult: BasicResult, SpecificResultProtocol {
    typealias SpecificResult = Issue
    typealias BasicResultType = IssuesResult
    
    @objc var issues: [SpecificResult]?
    
    var results: [Issue]? {
        get { return self.issues }
        set { self.issues = newValue }
    }
}
