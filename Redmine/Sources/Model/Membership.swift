//
//  Membership.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 08/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

@objc(Membership)
class Membership: Basic {
    @objc var project: Basic?
    @objc var roles: [Role]?
}
