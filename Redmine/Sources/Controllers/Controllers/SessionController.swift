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
    case authToken = "authToken"
}

class SessionController {
    var domain: String = ""
    var credentials: String = ""
    var authToken: String = ""
    
    var isValid: Bool {
        return !self.domain.isEmpty && !self.credentials.isEmpty && !self.authToken.isEmpty
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
    
    fileprivate func remove(key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    fileprivate func loadContent() {
        self.domain = self.string(for: .domain)
        self.credentials = self.string(for: .credentials)
        self.authToken = self.string(for: .authToken)
    }
    
    func save() {
        self.set(string: self.domain, for: .domain)
        self.set(string: self.credentials, for: .credentials)
        self.set(string: self.authToken, for: .authToken)
    }
    
    func logout() {
        self.remove(key: .domain)
        self.remove(key: .credentials)
        self.remove(key: .authToken)
    }
}
