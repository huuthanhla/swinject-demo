//
//  MarketTableViewModel.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import DemoModel
import ReactiveSwift

public final class MarketTableViewModel: IMarketTableViewModel {
    private let market: IMarket
    
    public var cellModels: Property<[IMarketTableViewCellModel]> { return Property(_cellModels) }
    
    fileprivate let _cellModels = MutableProperty<[IMarketTableViewCellModel]>([])
    
    public init(market: IMarket) {
        self.market = market
    }
    
    public func startGetMarkets() {
        func toCellModel(_ market: MarketEntity) -> IMarketTableViewCellModel {
            return MarketTableViewCellModel(market: market) as IMarketTableViewCellModel
        }
        
        market.getMarkets()
            .map { response in
                (response.result, response.result.map { toCellModel($0) })
            }
            .observe(on: UIScheduler())
            .on(value: { result, cellModels in
                self._cellModels.value += cellModels
            })
            .start()
    }
}
