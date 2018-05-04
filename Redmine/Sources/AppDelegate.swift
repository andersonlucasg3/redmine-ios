//
//  AppDelegate.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 13/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var navigationController: UINavigationController? {
        return self.window?.rootViewController as? UINavigationController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.configureNavigationBarAppearance()
        
        if self.checkHasSession() {
            self.navigationController?.setViewControllers([ProjectsViewController.instantiate()!], animated: false)
        }
        return true
    }
    
    fileprivate func checkHasSession() -> Bool {
        return SessionController().isValid
    }
    
    fileprivate func configureNavigationBarAppearance() {
        UINavigationBar.appearance().tintColor = Colors.applicationMainColor
    }
}

