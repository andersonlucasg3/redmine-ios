//
//  UIViewController+showAlert.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 12/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit.UIViewController

typealias Action = (title: String?, action: os_block_t)

extension UIViewController {
    @discardableResult
    func showAlert(withTitle title: String? = nil, message: String? = nil, cancelAction: Action? = nil, confirmAction: Action, presentationCompletion completion: os_block_t? = nil) -> UIAlertController? {
        guard title != nil || message != nil else { return nil }
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        self.createAction(from: cancelAction, into: alert, cancel: true)
        self.createAction(from: confirmAction, into: alert, cancel: false)
        self.present(alert, animated: true, completion: completion)
        return alert
    }
    
    fileprivate func createAction(from action: Action?, into alert: UIAlertController, cancel: Bool) {
        if let action = action, let title = action.title {
            alert.addAction(UIAlertAction.init(title: title, style: cancel ? .cancel : .default, handler: { _ in
                action.action()
            }))
        }
    }
}
