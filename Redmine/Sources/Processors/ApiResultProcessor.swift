//
//  ApiResultProcessor.swift
//  Redmine
//
//  Created by Anderson Lucas de Castro Ramos on 14/04/2018.
//  Copyright © 2018 InsaniTech. All rights reserved.
//

import Foundation
import Swift_Json

enum ApiResultProcessor<T: NSObject> {
    static func processResult(content: String?) -> T? {
        guard let content = content else { return nil }
        let config = JsonConfig.init(SnakeCaseConverter())
        config.set(fromKey: "subtitle", to: "description")
        let parser = JsonParser()
        return parser.parse(string: content, withConfig: config)
    }
}
