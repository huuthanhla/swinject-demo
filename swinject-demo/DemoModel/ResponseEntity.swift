//
//  ResponseEntity.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Himotoki

public struct ResponseEntity {
    public let success: Bool
    public let message: String
    public let result: [MarketEntity]
}

// MARK: Decodable
extension ResponseEntity: Decodable {
    public static func decode(_ e: Extractor) throws -> ResponseEntity {
        return try ResponseEntity(
            success: e <| "success",
            message: e <| "message",
            result: e <|| "result"
        )
    }
}
