//: Playground - noun: a place where people can play

import UIKit
import Swinject

var str = "Hello, playground"

protocol Animal {
    var name: String? { get }
}

class Cat: Animal {
    let name: String?
    init(name: String?) {
        self.name = name
    }
}

class Dog: Animal {
    let name: String?
    init(name: String?, nickName: String?) {
        let fullName = (name ?? "unknown ") + " " + (nickName ?? "the mighty")
        self.name = "Chip \(fullName)"
    }
}

protocol Person {
    func play()
}

class PetOwner: Person {
    let pet: Animal
    
    init(pet: Animal) {
        self.pet = pet
    }
    
    func play() {
        let name = pet.name ?? "someone"
        print("I'm playing with \(name).")
    }
}

let container = Container()
container.register(Animal.self) { _, name in Cat(name: name) }
container.register(Animal.self) { _, name, nickName in Dog(name: name, nickName: nickName) }
//container.register(Animal.self) { _ in Cat(name: "Cat the moon") }
container.register(Person.self) { r in
    PetOwner(pet: r.resolve(Animal.self)!)
}

let person = container.resolve(Person.self)!
person.play()