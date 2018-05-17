//
//  String+slugify.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 17/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

extension String {
    private static let allowedCharacters = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")
    
    public func slugify() -> String {
        let cocoaString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(cocoaString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(cocoaString, nil, kCFStringTransformStripCombiningMarks, false)
        CFStringLowercase(cocoaString, .none)
        
        return String(cocoaString)
            .components(separatedBy: String.allowedCharacters.inverted)
            .filter { $0 != "" }
            .joined(separator: "-")
    }
}
