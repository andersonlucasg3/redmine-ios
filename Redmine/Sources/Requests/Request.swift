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
    case noResponse
    case statusCode(code: Int, content: String?)
    case noInternetConnection
}

protocol RequestDelegate : class {
    func request(_ request: Request, didFinishWithContent content: String?)
    func request(_ request: Request, didFailWithError error: RequestError)
}

class Request {
    fileprivate var dataRequest: DataRequest?
    
    fileprivate(set) var url: String
    fileprivate(set) var method: HTTPMethod
    
    var parameters: (params: Parameters, encoding: ParameterEncoding)?
    var headers: HTTPHeaders?
    
    weak var delegate: RequestDelegate?
    
    init(_ url: String, method: HTTPMethod) {
        self.url = url
        self.method = method
        
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
            guard let response = $0.response else {
                self?.dispatchError(.noResponse)
                return
            }
            if self?.checkSuccess($0.response) ?? false {
                self?.dispatchSuccess($0.value)
            } else {
                self?.dispatchError(.statusCode(code: response.statusCode, content: $0.value))
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

