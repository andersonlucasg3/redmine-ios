//
//  LoginViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 13/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import Swift_Json

class LoginViewController: UIViewController, RequestDelegate {
    @IBOutlet fileprivate weak var domainUrlTextField: UITextField!
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var loginButton: UIButton!
    
    fileprivate let defaultDomain: String = "http://redmine.org"
    fileprivate var loginRequest: Request!
    
    fileprivate let sessionController = SessionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func getDomain() -> String {
        if (self.domainUrlTextField.text ?? "").isEmpty {
            return self.defaultDomain
        }
        return self.domainUrlTextField.text ?? ""
    }
    
    fileprivate func createRequest() {
        self.sessionController.domain = self.getDomain()
        self.loginRequest = Request(url: Ambients.getProjectsPath(with: self.sessionController), method: .get)
        self.loginRequest.addBasicAuthorizationHeader(username: self.usernameTextField.text ?? "",
                                                 password: self.passwordTextField.text ?? "")
        self.loginRequest.delegate = self
    }
    
    fileprivate func checkCanLogin() -> Bool {
        return !(self.usernameTextField.text ?? "").isEmpty && !(self.passwordTextField.text ?? "").isEmpty
    }
    
    fileprivate func showFulfillAlert() {
        let alert = UIAlertController(title: "Oops", message: "Please, fulfill the login information correctly.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
            self?.domainUrlTextField.becomeFirstResponder()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func saveValidCredentials() {
        self.sessionController.credentials = createBasicCredentials(self.usernameTextField.text ?? "", self.passwordTextField.text ?? "")
        self.sessionController.save()
    }
    
    fileprivate func openProjectsViewController(_ projects: ProjectResult) {
        
    }
    
    // MARK: Buttons events
    
    @IBAction fileprivate func loginButton(_ sender: UIButton) {
        if self.checkCanLogin() {
            self.createRequest()
            self.loginRequest.start()
        } else {
            self.showFulfillAlert()
        }
    }
    
    // MARK: RequestDelegate
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        guard let projects: ProjectResult = ApiResultProcessor.processResult(content: content) else {
            self.request(request, didFailWithError: .statusCode(code: 404, content: content))
            return
        }
        
        self.saveValidCredentials()
        self.openProjectsViewController(projects)
    }
    
    func request(_ request: Request, didFailWithError error: RequestError) {
        print(#function)
        print(error)
    }
}

