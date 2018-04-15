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
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if self.checkHasSession() {
            self.createNavigationController(with: ProjectsViewController.instantiate()!)
        } else {
            self.createNavigationController(with: LoginViewController.instantiate()!)
        }
        
        self.createWindow()
        
        return true
    }
    
    fileprivate func createWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
    }
    
    fileprivate func createNavigationController(with root: UIViewController) {
        self.navigationController = UINavigationController(rootViewController: root)
    }
    
    fileprivate func checkHasSession() -> Bool {
        return SessionController().isValid
    }
}

