//
//  UITableViewCell+Zebra.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 17/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import UIKit.UITableViewCell

extension UITableViewCell {
    func configureBackground(at indexPath: IndexPath) {
        // application default zebra colors
        self.backgroundColor = indexPath.row % 2 == 0 ? #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 0.1531999144) : UIColor.white
    }
}
