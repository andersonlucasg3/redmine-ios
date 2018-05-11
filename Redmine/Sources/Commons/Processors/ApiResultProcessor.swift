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
    static func processResult(content: String?, customMapping: [String: String]? = nil) -> T? {
        guard let content = content else { return nil }
        let config = JsonConfig.init(SnakeCaseConverter())
        config.set(fromKey: "subtitle", to: "description")
        config.set(forField: "value") { (object, key) -> AnyObject? in
            if object is String {
                return [object] as AnyObject
            } else if object is NSNull {
                return nil
            }
            return object
        }
        if let mapping = customMapping {
            mapping.keys.forEach({ key in
                config.set(fromKey: key, to: mapping[key] ?? "")
            })
        }
        let parser = JsonParser()
        return parser.parse(string: content, withConfig: config)
    }
}
