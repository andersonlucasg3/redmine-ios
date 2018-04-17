//
//  UserContentLoader.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 16/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

struct UserContentDefinition: RawRepresentable {
    typealias RawValue = Int
    
    var rawValue: Int
    
    init?(rawValue: Int) {
        self.rawValue = rawValue
    }
}

enum UserContentType {
//    case project =
}

class UserContentLoader {
    fileprivate var request: Request!
    
    init() {
        
    }
    
    func loadAll() {
        
    }
}
