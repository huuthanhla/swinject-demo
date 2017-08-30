//
//  IMarket.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import ReactiveSwift

public protocol IMarket {
    func getMarkets() -> SignalProducer<ResponseEntity, NetworkError>
}
