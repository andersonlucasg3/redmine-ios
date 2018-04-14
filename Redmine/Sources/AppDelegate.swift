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
        
        // TODO: if logged then shit happens
        self.createNavigationController(with: LoginViewController.instantiate()!)
        
        return true
    }
    
    fileprivate func createNavigationController(with root: UIViewController) {
        self.navigationController = UINavigationController(rootViewController: root)
    }
}

