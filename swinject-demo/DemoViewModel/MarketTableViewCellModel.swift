//
//  MarketTableViewCellModel.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import DemoModel

public final class MarketTableViewCellModel: IMarketTableViewCellModel {
    public let marketName: String
    public let logoUrl: String?
    
    internal init(market: MarketEntity) {
        self.marketName = market.marketName
        self.logoUrl = market.logoUrl
    }
}
