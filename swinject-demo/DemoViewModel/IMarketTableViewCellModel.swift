//
//  IMarketTableViewCellModel.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

public protocol IMarketTableViewCellModel {
    var marketName: String { get }
    var logoUrl: String? { get }
}
