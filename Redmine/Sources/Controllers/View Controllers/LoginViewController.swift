//
//  LoginViewController.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 13/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit
import Swift_Json
import PKHUD
import Reachability
import Alamofire

class LoginViewController: UIViewController, RequestProtocol {
    @IBOutlet fileprivate weak var domainUrlTextField: UITextField!
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    @IBOutlet fileprivate weak var loginButton: UIButton!
    
    fileprivate let defaultDomain: String = "http://redmine.org"
    fileprivate var loginRequest: Request!
    
    fileprivate let sessionController = SessionController()
    
    fileprivate func getDomain() -> String {
        if (self.domainUrlTextField.text ?? "").isEmpty {
            return self.defaultDomain
        }
        return self.domainUrlTextField.text ?? ""
    }
    
    fileprivate func fixDomainIfNeeded() -> String {
        let domain = self.getDomain()
        return domain.contains("://") ? domain : "http://\(domain)"
    }
    
    fileprivate func createParameters() -> RequestParameters {
        let params = ["username": self.usernameTextField.text ?? "", "password": self.passwordTextField.text ?? ""]
        let encoding = URLEncoding.httpBody
        return (params: params, encoding: encoding)
    }
    
    fileprivate func createRequest() {
        self.sessionController.domain = self.fixDomainIfNeeded()
        self.loginRequest = Request(url: Ambients.getLoginPath(with: self.sessionController), method: .post)
        self.loginRequest.parameters = self.createParameters()
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
    
    fileprivate func saveValidCredentials(_ authToken: String) {
        self.sessionController.credentials = createBasicCredentials(self.usernameTextField.text ?? "", self.passwordTextField.text ?? "")
        self.sessionController.authToken = authToken
        self.sessionController.save()
    }
    
    fileprivate func openProjectsViewController() {
        self.navigationController?.setViewControllers([ProjectsViewController.instantiate()!], animated: true)
    }
    
    fileprivate func isSuccessStatusCode(_ statusCode: Int) -> Bool {
        return statusCode == 200 || statusCode == 422
    }
    
    fileprivate func containsSetCookie(inResponse headers: [AnyHashable: Any]) -> Bool {
        let setCookie = headers["Set-Cookie"] as! String
        return !setCookie.isEmpty
    }
    
    // MARK: Buttons events
    
    @IBAction fileprivate func loginButton(_ sender: UIButton) {
        if self.checkCanLogin() {
            HUD.show(.progress, onView: self.view)
            
            self.createRequest()
            self.loginRequest.start()
        } else {
            self.showFulfillAlert()
        }
    }
    
    // MARK: RequestDelegate
    
    func request(_ request: Request, didReceiveResponse response: HTTPURLResponse?) {
        weak var this = self
        func redirectLoginError() {
            this?.request(request, didFailWithError: RequestError.statusCode(code: 404, content: nil))
        }
        
        guard let response = response else {
            redirectLoginError()
            return
        }
        
        if self.isSuccessStatusCode(response.statusCode) && self.containsSetCookie(inResponse: response.allHeaderFields) {
            self.saveValidCredentials(response.allHeaderFields["Set-Cookie"] as! String)
            self.openProjectsViewController()
            
            HUD.show(.success, onView: self.view)
            HUD.hide(afterDelay: 1.0)
        } else {
            redirectLoginError()
        }
    }
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        // Do nothing
    }
    
    func request(_ request: Request, didFailWithError error: Error) {
        print(#function)
        print(error)
        
        let message: String = Reachability.forInternetConnection().isReachable() ?
            "Wrong Username\nand/or Password." :
            "Please, check for internet connection."
        HUD.show(.labeledError(title: "Login failed", subtitle: message), onView: self.view)
        HUD.hide(afterDelay: 2.0)
    }
}

