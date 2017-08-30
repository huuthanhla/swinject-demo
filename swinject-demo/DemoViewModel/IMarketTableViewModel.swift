//
//  IMarketTableViewModel.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import ReactiveSwift
import Result

public protocol IMarketTableViewModel {
    var cellModels: Property<[IMarketTableViewCellModel]> { get }
    func startGetMarkets()
}
