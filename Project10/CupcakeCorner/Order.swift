//
//  Order.swift
//  CupcakeCorner
//
//  Created by Anmol  Jandaur on 12/15/20.
//

// We’ve organized our code so that we have one Order object that gets shared between all our screens, which has the advantage that we can move back and forward between those screens without losing data. However, this approach comes with a cost: we’ve had to use the @Published property wrapper for the properties in the class, and as soon we did that we lost support for automatic Codable conformance.

import SwiftUI

// MARK: Challenge 3 - convert our data model from a class to a struct, then create an ObservableObject class wrapper around it that gets passed around. This will result in your class having one @Published property, which is the data struct inside it, and should make supporting Codable on the struct much easier.

class OrderWrapper : ObservableObject {
    @Published var order : Order
    
    init() {
       order = Order(type: 0, quantity: 3, specialRequestEnabled: false, extraFrosting: false, addSprinkles: false, name: "", streetAddress: "", city: "", zip: "")
    }
}

struct Order:  Codable {
    
    // The fix here is to add Codable conformance by hand, which means telling Swift what should be encoded, how it should be encoded, and also how it should be decoded – converted back from JSON to Swift data.
    
    // That first step means adding an enum that conforms to CodingKey, listing all the properties we want to save.
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
//    // The second step requires us to write an encode(to:) method that creates a container using the coding keys enum we just created, then writes out all the properties attached to their respective key. This is just a matter of calling encode(_:forKey:) repeatedly, each time passing in a different property and coding key.
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(type, forKey: .type)
//        try container.encode(quantity, forKey: .quantity)
//
//        try container.encode(extraFrosting, forKey: .extraFrosting)
//        try container.encode(addSprinkles, forKey: .addSprinkles)
//
//        try container.encode(name, forKey: .name)
//        try container.encode(streetAddress, forKey: .streetAddress)
//        try container.encode(city, forKey: .city)
//        try container.encode(zip, forKey: .zip)
//
//    }
//
//    // Our final step is to implement a required initializer to decode an instance of Order from some archived data. This is pretty much the reverse of encoding, and even benefits from the same throws functionality
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        type = try container.decode(Int.self, forKey: .type)
//        quantity = try container.decode(Int.self, forKey: .quantity)
//
//        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
//        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
//
//        name = try container.decode(String.self, forKey: .name)
//        streetAddress = try container.decode(String.self, forKey: .streetAddress)
//        city = try container.decode(String.self, forKey: .city)
//        zip = try container.decode(String.self, forKey: .zip)
//
//        // It’s worth adding here that you can encode your data in any order you want – you don’t need to match the order in which properties are declared in your object
//    }
//    // The problem now is that we just created a custom initializer for our Order class, init(from:), and Swift wants us to use it everywhere – even in places where we just want to create a new empty order because the app just started
//
//    // we need to write a new initializer that can create an order without any data whatsoever – it will rely entirely on the default property values we assigned.
//    init() { }

    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    // add a didSet property so that extraFrosting and addSprinkles are reset to false when
    // specicalRequestEnabled is set to false
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    // delivery details
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    // check whether user inputs valid delivery data
    var hasValidAddress: Bool {
        // Challenge 1: Our address fields are currently considered valid if they contain anything, even if it’s just only whitespace. Improve the validation to make sure a string of pure whitespace is invalid.
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty
        {
            return false
        }
        
        return true
    }
    
    // computed property for the order cost
    var cost: Double {
        // $2 per cake
        var cost = (Double(type) / 2)
        
        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }
        
        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}
