//
//  LoginViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 13/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var loginButton: UIButton!
    
    fileprivate let request: Request = Request(<#T##url: String##String#>, method: <#T##HTTPMethod#>)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: Buttons events
    
    @IBAction fileprivate func loginButton(_ sender: UIButton) {
        
    }
}

