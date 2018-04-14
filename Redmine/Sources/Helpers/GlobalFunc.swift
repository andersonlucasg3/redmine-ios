//
//  GlobalFunc.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation

func mainAsync(_ block: @escaping os_block_t) {
    DispatchQueue.main.async(execute: block)
}

func mainSync(_ block: @escaping os_block_t) {
    DispatchQueue.main.sync(execute: block)
}

func globalAsync(_ block: @escaping os_block_t) {
    DispatchQueue.global().async(execute: block)
}

func globalSync(_ block: @escaping os_block_t) {
    DispatchQueue.global().sync(execute: block)
}
