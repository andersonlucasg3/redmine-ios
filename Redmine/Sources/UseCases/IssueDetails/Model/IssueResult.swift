//
//  IssueResult.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 24/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class IssueResult: BasicResult, SpecificResultProtocol {
    @objc var issue: Issue?
    
    var results: [Issue]? {
        get { return [self.issue!] }
        set { self.issue = newValue?.first }
    }
}
