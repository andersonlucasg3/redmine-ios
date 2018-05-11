//
//  User.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 08/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

class User: Basic {
    override var name: String? {
        get { return "\(self.firstname ?? "") \(self.lastname ?? "")" }
        set { }
    }
    
    @objc var login: String?
    @objc var firstname: String?
    @objc var lastname: String?
    @objc var mail: String?
    @objc var createdOn: String?
    @objc var lastLoginOn: String?
    @objc var apiKey: String?
    @objc var customFields: [CustomField]?
    @objc var memberships: [Membership]?
}
