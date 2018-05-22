//
//  SettingsController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 20/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import FileKit
import Swift_Json

class SettingsController {
    fileprivate let settingsPath = Path.userCaches + "settings"
    fileprivate lazy var settingsFilePath = self.settingsPath + "settings.json"
    
    fileprivate(set) var settings: Settings = Settings.init()
    
    init() {
        try? self.settingsPath.createDirectory()
        
        self.loadSettings()
    }
    
    fileprivate func loadSettings() {
        guard let jsonString = try? String.init(contentsOfFile: self.settingsFilePath.description) else { return }
        let parser = JsonParser.init()
        self.settings = parser.parse(string: jsonString)!
    }
    
    func saveSettings() {
        let writer = JsonWriter.init()
        let jsonString: String = writer.write(anyObject: self.settings)!
        try! jsonString.write(to: self.settingsFilePath)
    }
}
