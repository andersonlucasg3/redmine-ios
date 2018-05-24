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

enum RequestError: Error {
    case statusCode(code: Int, content: String?)
    case failure(error: Error)
    case noInternetConnection
}

@objc protocol RequestProtocol : class {
    @objc optional func request(_ request: Request, didReceiveResponse response: HTTPURLResponse?)
    func request(_ request: Request, didFinishWithContent content: String?)
    func request(_ request: Request, didFailWithError error: Error)
}

fileprivate func createBasicCredentials(_ username: String, _ password: String) -> String {
    let userCredentials = "\(username):\(password)"
    let data = userCredentials.data(using: .utf8)
    return "Basic \(data?.base64EncodedString() ?? "failed")"
}

typealias RequestParameters = (params: Parameters, encoding: ParameterEncoding)

enum RequestBodyType {
    case formUrlEncoded
    case json
}

class Request: NSObject {
    fileprivate var dataRequest: DataRequest?
    
    fileprivate(set) var url: String
    fileprivate(set) var method: HTTPMethod
    
    var parameters: RequestParameters?
    var headers: HTTPHeaders?
    var bodyType: RequestBodyType = .formUrlEncoded
    var bodyContent: Data?
    
    weak var delegate: RequestProtocol?
    
    init(url: String, method: HTTPMethod, disableCaches: Bool = false) {
        self.url = url
        self.method = method
        
        if disableCaches {
            SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringCacheData
            SessionManager.default.session.configuration.urlCache = nil
        }
    }
    
    func addBasicAuthorizationHeader(username: String, password: String) {
        self.addBasicAuthorizationHeader(credentials: createBasicCredentials(username, password))
    }
    
    func addBasicAuthorizationHeader(credentials: String) {
        self.addHeader(for: "Authorization", with: credentials)
    }
    
    func addHeader(for key: String, with value: String) {
        if self.headers == nil {
            self.headers = [ key : value ]
        } else {
            self.headers?[key] = value
        }
    }
    
    func start() {
        guard Reachability.forInternetConnection().isReachable() else {
            self.delegate?.request(self, didFailWithError: RequestError.noInternetConnection)
            return
        }
        
        print("[Request.swift] headers: \(self.headers ?? [:])")
        print("[Request.swift] parameters: \(self.parameters?.params ?? [:])")
        
        switch self.bodyType {
        case .formUrlEncoded: self.startRequestUrlFormEncoded()
        case .json: self.startJson()
        }
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
    
    fileprivate func completionHandler(_ response: DataResponse<String>) {
        print("\(#file)-\(#function)-\(#line)")
        print(response)
        
        self.dispatchResponse(response.response)
        
        let statusCode = response.response?.statusCode ?? 0
        guard statusCode >= 200 && statusCode <= 299 else {
            self.dispatchError(.statusCode(code: statusCode, content: response.result.value))
            return
        }
        
        switch response.result {
        case .success(let value):
            self.dispatchSuccess(value)
        case .failure(let error):
            self.dispatchError(.failure(error: error))
        }
    }
    
    fileprivate func startRequestUrlFormEncoded() {
        self.dataRequest = SessionManager.default.request(self.url,
                                                          method: self.method,
                                                          parameters: self.parameters?.params,
                                                          encoding: self.parameters?.encoding ?? URLEncoding.default,
                                                          headers: self.headers)
        if let dr = self.dataRequest { print(dr) }
        self.dataRequest?.responseString(completionHandler: { [weak self] response in self?.completionHandler(response) })
    }
    
    fileprivate func startJson() {
        self.dataRequest = SessionManager.default.upload(self.bodyContent!,
                                                         to: self.url,
                                                         method: self.method,
                                                         headers: self.headers)
        if let dr = self.dataRequest { print(dr) }
        self.dataRequest?.responseString(completionHandler: { [weak self] response in self?.completionHandler(response) })
    }
    
    fileprivate func checkSuccess(_ response: HTTPURLResponse?) -> Bool {
        guard let response = response else { return false }
        return response.statusCode >= 200 && response.statusCode <= 299
    }
    
    fileprivate func dispatchResponse(_ response: HTTPURLResponse?) {
        mainAsync { [weak self] in
            guard let this = self else { return }
            this.delegate?.request?(this, didReceiveResponse: response)
        }
    }

    fileprivate func dispatchError(_ error: RequestError) {
        mainAsync { [weak self] in
            guard let this = self else { return }
            this.delegate?.request(this, didFailWithError: error)
        }
    }
    
    fileprivate func dispatchSuccess(_ content: String?) {
        mainAsync { [weak self] in
            guard let this = self else { return }
            this.delegate?.request(this, didFinishWithContent: content)
        }
    }
}

