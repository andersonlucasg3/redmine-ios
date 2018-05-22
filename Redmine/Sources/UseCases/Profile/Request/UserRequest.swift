//
//  UserRequest.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 20/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

protocol UserRequestProtocol: class {
    func userRequest(_ request: UserRequest, didFinishWithSuccess user: User)
    func userRequest(_ request: UserRequest, didFailWithError error: Error)
}

class UserRequest: RequestProtocol {
    fileprivate let request: Request
    
    weak var delegate: UserRequestProtocol?
    
    init(username: String, password: String, and sessionController: SessionController) {
        self.request = Request(url: Ambients.getLoginPath(with: sessionController), method: .get)
        self.request.addBasicAuthorizationHeader(username: username,
                                                 password: password)
        self.request.delegate = self
    }
    
    init(sessionController: SessionController) {
        self.request = Request.init(url: Ambients.getLoginPath(with: sessionController), method: .get)
        self.request.addHeader(for: "X-Redmine-API-Key", with: sessionController.user?.apiKey ?? "")
        self.request.delegate = self
    }
    
    func start() {
        self.request.start()
    }
    
    // MARK: RequestProtocol
    
    func request(_ request: Request, didFinishWithContent content: String?) {
        weak var this = self
        func redirectLoginError() {
            this?.request(request, didFailWithError: RequestError.statusCode(code: 404, content: nil))
        }
        
        guard let content = content,
            let userResult: UserResult = ApiResultProcessor.processResult(content: content),
            let user = userResult.user
        else {
            redirectLoginError()
            return
        }
        
        self.delegate?.userRequest(self, didFinishWithSuccess: user)
    }
    
    func request(_ request: Request, didFailWithError error: Error) {
        print(#function)
        print(error)
        
        self.delegate?.userRequest(self, didFailWithError: error)
    }
}
