//: Playground - noun: a place where people can play

import UIKit
import Swinject

protocol IPayment {
    var currency: String { get }
    func description() -> String
}

class CreditCard: IPayment {
    let currency: String
    
    init(currency: String) {
        self.currency = currency
    }
    
    func description() -> String {
        return "Visa/Master Credit Card"
    }
}

class Bitcoin: IPayment {
    let currency: String = "BTC"
    
    func description() -> String {
        return "Bitcoin"
    }
}

class Order {
    let payment: IPayment
    
    init(payment: IPayment) {
        self.payment = payment
    }
    
    func confirmPayment() -> String {
        return "Your order will be paid in \(payment.currency) with \(payment.description())!"
    }
}


// MARK: - WITHOUT SWINJECT
let creditCard = CreditCard(currency: "JPY")
let orderOne = Order(payment: creditCard)
print(orderOne.confirmPayment())

let bitcoin = Bitcoin()
let orderTwo = Order(payment: bitcoin)
print(orderTwo.confirmPayment())

// MARK: - WITH SWINJECT
let container = Container()
container.register(IPayment.self) { _ in Bitcoin() }
container.register(Order.self) { r in
    Order(payment: r.resolve(IPayment.self)!)
}

let swinjectOrder = container.resolve(Order.self)!
print(swinjectOrder.confirmPayment())