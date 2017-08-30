//
//  Network.swift
//  swinject-demo
//
//  Created by Ominext Mobile's on 8/30/17.
//  Copyright © 2017 Ominext. All rights reserved.
//

import Foundation
import ReactiveSwift
import Alamofire

public final class Network: Networking {
    private let queue = DispatchQueue(label: "SwinjectMMVMExample.ExampleModel.Network.Queue", attributes: [])
    
    public init() { }
    
    public func requestJSON(_ url: String, parameters: [String : AnyObject]?) -> SignalProducer<Any, NetworkError> {
        return SignalProducer { observer, disposable in
            Alamofire.request(url, method: .get, parameters: parameters)
                .response(queue: self.queue, responseSerializer: Alamofire.DataRequest.jsonResponseSerializer()) { response in
                    switch response.result {
                    case .success(let value):
                        observer.send(value: value)
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: NetworkError(error: error as NSError))
                    }
            }
        }
    }
}
