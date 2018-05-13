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
    
    fileprivate func createRequest() {
        self.sessionController.domain = self.fixDomainIfNeeded()
        self.loginRequest = Request(url: Ambients.getLoginPath(with: self.sessionController), method: .get)
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
    
    fileprivate func saveUser(_ user: User?) {
        self.sessionController.user = user
        self.sessionController.save()
    }
    
    fileprivate func openMainTabBarController() {
        UIApplication.shared.keyWindow?.rootViewController = MainTabBarViewController.instantiate()!
    }
    
    // MARK: Buttons events
    
    @IBAction fileprivate func loginButton(sender: UIButton) {
        #if MOCKED
        let mockContent = try? String.init(contentsOfFile: Bundle.main.path(forResource: "currentUser", ofType: "json") ?? "path")
        self.request(Request.init(url: "", method: .get), didFinishWithContent: mockContent)
        #else
        if self.checkCanLogin() {
            HUD.show(.progress, onView: self.view)
            
            self.createRequest()
            self.loginRequest.start()
        } else {
            self.showFulfillAlert()
        }
        #endif
    }
    
    // MARK: RequestDelegate
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        weak var this = self
        func redirectLoginError() {
            this?.request(request, didFailWithError: RequestError.statusCode(code: 404, content: nil))
        }
        
        guard let content = content, let userResult: UserResult = ApiResultProcessor.processResult(content: content) else {
            redirectLoginError()
            return
        }
        
        self.saveUser(userResult.user)
        self.openMainTabBarController()
        
        HUD.show(.success, onView: self.view)
        HUD.hide(afterDelay: 1.0)
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

