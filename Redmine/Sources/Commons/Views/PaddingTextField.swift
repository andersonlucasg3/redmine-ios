//
//  PaddingTextField.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 16/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit

// MARK: UITextField

@IBDesignable
class PaddingTextField: UITextField {
    @IBInspectable var padding: CGRect = CGRect.zero
    @IBInspectable var placeholderColor: UIColor? {
        get { return self.value(forKeyPath: "_placeholderLabel.textColor") as? UIColor }
        set { self.setValue(newValue, forKeyPath: "_placeholderLabel.textColor") }
    }
    
    fileprivate func padding(for bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + self.padding.origin.x,
               y: bounds.origin.y + self.padding.origin.y,
               width: bounds.width - self.padding.origin.x - self.padding.width,
               height: bounds.height - self.padding.origin.y - self.padding.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return self.padding(for: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.padding(for: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.padding(for: bounds)
    }
}
