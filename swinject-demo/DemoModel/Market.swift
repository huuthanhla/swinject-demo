//
//  Market.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import ReactiveSwift
import Result
import Himotoki

public final class Market: IMarket {
    private let network: Networking
    
    public init(network: Networking) {
        self.network = network
    }
    
    public func getMarkets() -> SignalProducer<ResponseEntity, NetworkError> {
        let url = Bittrex.apiURL + "public/getmarkets"
        return self.network.requestJSON(url, parameters: nil).attemptMap { json in
            do {
                let response = try ResponseEntity.decodeValue(json)
                return Result(value: response)
            } catch {
                print(error.localizedDescription)
                return Result(error: .IncorrectDataReturned)
            }
//            let response = ResponseEntity.decodeValue(json)
//            return Result(value: response)
//            if let response = try? ResponseEntity.decodeValue(json) {
//                return Result(value: response)
//            }
//            else {
//                return Result(error: .IncorrectDataReturned)
//            }
        }
        
    }
}
