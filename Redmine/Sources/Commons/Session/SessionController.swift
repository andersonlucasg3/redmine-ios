//
//  Configurations.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import Swift_Json

fileprivate enum Keys: String {
    case domain = "domain"
    case user = "user"
}

class SessionController {
    var domain: String = ""
    var user: User?
    
    var isValid: Bool {
        return !self.domain.isEmpty && self.user != nil
    }
    
    init() {
        self.loadContent()
    }
    
    fileprivate func string(for key: Keys) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    fileprivate func object<T : NSObject>(for key: Keys) -> T? {
        let jsonString = self.string(for: key)
        return JsonParser().parse(string: jsonString)
    }
    
    fileprivate func set(string: String, for key: Keys) {
        UserDefaults.standard.set(string, forKey: key.rawValue)
    }
    
    fileprivate func set<T: NSObject>(object: T, for key: Keys) {
        if let jsonString: String = JsonWriter().write(anyObject: object) {
            self.set(string: jsonString, for: key)
        }
    }
    
    fileprivate func remove(key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    fileprivate func loadContent() {
        self.domain = self.string(for: .domain)
        self.user = self.object(for: .user)
    }
    
    func save() {
        self.set(string: self.domain, for: .domain)
        if let user = self.user { self.set(object: user, for: .user) }
    }
    
    func logout() {
        self.remove(key: .domain)
        self.remove(key: .user)
    }
}
