//
//  Configurations.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

fileprivate enum Keys: String {
    case domain = "domain"
    case credentials = "credentials"
}

class SessionController {
    var domain: String = ""
    var credentials: String = ""
    
    var isValid: Bool {
        return !self.domain.isEmpty && !self.credentials.isEmpty
    }
    
    init() {
        self.loadContent()
    }
    
    fileprivate func string(for key: Keys) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }
    
    fileprivate func set(string: String, for key: Keys) {
        UserDefaults.standard.set(string, forKey: key.rawValue)
    }
    
    fileprivate func loadContent() {
        self.domain = self.string(for: .domain)
        self.credentials = self.string(for: .credentials)
    }
    
    func save() {
        self.set(string: self.domain, for: .domain)
        self.set(string: self.credentials, for: .credentials)
    }
}
