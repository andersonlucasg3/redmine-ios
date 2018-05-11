//
//  DateStringProcessor.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 15/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

enum DateStringProcessor {
    static func dateString(for formated: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let date = formatter.date(from: formated) else { return formated }
        formatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
