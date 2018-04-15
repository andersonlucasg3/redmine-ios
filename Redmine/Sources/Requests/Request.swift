//
//  Request.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import Alamofire
import Reachability

enum RequestError {
    case statusCode(code: Int, content: String?)
    case failure(error: Error)
    case noInternetConnection
}

protocol RequestProtocol : class {
    func request(_ request: Request, didFinishWithContent content: String?)
    func request(_ request: Request, didFailWithError error: RequestError)
}

func createBasicCredentials(_ username: String, _ password: String) -> String {
    let userCredentials = "\(username):\(password)"
    let data = userCredentials.data(using: .utf8)
    return "Basic \(data?.base64EncodedString() ?? "failed")"
}

class Request {
    fileprivate var dataRequest: DataRequest?
    
    fileprivate(set) var url: String
    fileprivate(set) var method: HTTPMethod
    
    var parameters: (params: Parameters, encoding: ParameterEncoding)?
    var headers: HTTPHeaders?
    
    weak var delegate: RequestProtocol?
    
    init(url: String, method: HTTPMethod) {
        self.url = url
        self.method = method
        
    }
    
    func addBasicAuthorizationHeader(username: String, password: String) {
        if self.headers == nil {
            self.headers = [ "Authorization" : createBasicCredentials(username, password) ]
        } else {
            self.headers?["Authorization"] = createBasicCredentials(username, password)
        }
    }
    
    func addBasicAuthorizationHeader(credentials: String) {
        if self.headers == nil {
            self.headers = [ "Authorization" : credentials ]
        } else {
            self.headers?["Authorization"] = credentials
        }
    }
    
    func start() {
        guard Reachability.forInternetConnection().isReachable() else {
            self.delegate?.request(self, didFailWithError: .noInternetConnection)
            return
        }
        
        self.dataRequest = SessionManager.default.request(url,
                                                          method: self.method,
                                                          parameters: self.parameters?.params,
                                                          encoding: self.parameters?.encoding ?? URLEncoding.default,
                                                          headers: self.headers)
        self.dataRequest?.responseString(completionHandler: { [weak self] in
            switch $0.result {
            case .success(let value):
                self?.dispatchSuccess(value)
            case .failure(let error):
                self?.dispatchError(.failure(error: error))
            }
        })
    }
    
    func pause() {
        if let request = self.dataRequest {
            request.suspend()
        }
    }
    
    func discard() {
        if let request = self.dataRequest {
            request.cancel()
            self.dataRequest = nil
        }
    }
    
    fileprivate func checkSuccess(_ response: HTTPURLResponse?) -> Bool {
        guard let response = response else { return false }
        return response.statusCode >= 200 && response.statusCode <= 299
    }

    fileprivate func dispatchError(_ error: RequestError) {
        mainAsync { [weak self] in
            guard let _ = self else { return }
            self?.delegate?.request(self!, didFailWithError: error)
        }
    }
    
    fileprivate func dispatchSuccess(_ content: String?) {
        mainAsync { [weak self] in
            guard let _ = self else { return }
            self?.delegate?.request(self!, didFinishWithContent: content)
        }
    }
}

