//
//  SearchItem.swift
//  Redmine
//
//  Created by Anderson Lucas C. Ramos on 06/05/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

@objc(SearchItem)
class SearchItem: Basic {
    @objc var title: String?
    @objc var type: String?
    @objc var url: String?
    @objc var subtitle: String?
    @objc var datetime: String?
}
