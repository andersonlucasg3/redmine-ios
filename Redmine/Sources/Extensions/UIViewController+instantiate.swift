//
//  UIViewController+instantiate.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit

extension UIViewController {
    fileprivate static func storyboardName() -> String {
        let clsName = self.className
        let parts = clsName.split(separator: ".")
        if parts.count > 1 {
            return String(parts[1])
        }
        return clsName
    }
    
    static func getStoryboard() -> UIStoryboard {
        return UIStoryboard(name: self.storyboardName(), bundle: Bundle.main)
    }
    
    static func instantiate<T: UIViewController>(for identifier: String? = nil) -> T? {
        let storyboard = self.getStoryboard()
        if let id = identifier {
            return storyboard.instantiateViewController(withIdentifier: id) as? T
        }
        return storyboard.instantiateInitialViewController() as? T
    }
    
    static func instantiate(_ identifier: String? = nil) -> Self? {
        return self.instantiate(for: identifier)
    }
}
