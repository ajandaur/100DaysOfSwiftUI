//
//  Card.swift
//  Flashzilla
//
//  Created by Anmol  Jandaur on 1/13/21.
//

import Foundation

struct Card: Codable, Identifiable {
    let id = UUID()
    let prompt: String
    let answer: String

    
    static var example: Card {
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
