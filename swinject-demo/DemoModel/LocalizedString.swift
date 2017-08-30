//
//  LocalizedString.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

internal func LocalizedString(_ key: String, comment: String?) -> String {
    struct Static {
        static let bundle = Bundle(identifier: "com.ominext.swinject-demo.DemoModel")!
    }
    return NSLocalizedString(key, bundle: Static.bundle, comment: comment ?? "")
}
