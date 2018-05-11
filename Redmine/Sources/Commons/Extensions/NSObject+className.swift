//
//  NSObject+className.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return "\(self)"
    }
    
    var className: String {
        return "\(self.classForCoder)"
    }
}
