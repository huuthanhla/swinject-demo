//
//  MarketEntity.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Himotoki

public struct MarketEntity {
    public let marketCurrency: String
    public let baseCurrency: String
    public let marketCurrencyLong: String
    public let baseCurrencyLong: String
    public let minTradeSize: Float
    public let marketName: String
    public let isActive: Bool
    public let logoUrl: String?
}

// MARK: Decodable
extension MarketEntity: Decodable {
    public static func decode(_ e: Extractor) throws -> MarketEntity {
        return try MarketEntity(
            marketCurrency: e <| "MarketCurrency",
            baseCurrency: e <| "BaseCurrency",
            marketCurrencyLong: e <| "MarketCurrencyLong",
            baseCurrencyLong: e <| "BaseCurrencyLong",
            minTradeSize: e <| "MinTradeSize",
            marketName: e <| "MarketName",
            isActive: e <| "IsActive",
            logoUrl: e <|? "LogoUrl"
        )
    }
}
