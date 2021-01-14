//
//  Card.swift
//  Flashzilla
//
//  Created by Anmol  Jandaur on 1/13/21.
//

import Foundation

struct Card {
    let prompt: String
    let answer: String
    
    var timesShown = 1
    var timesCorrect = 0
    
    mutating func correctChoice() {
        timesCorrect += 1
        timesShown += 1
    }
    
    mutating func wrongChoice() {
        timesShown += 1
    }
    
    // percentage correct of the particular Card
    var percentageCorrect: Double {
        let finalCalc = timesCorrect/timesShown
        return Double(finalCalc)
    }
    
    // number of times shown and number of times correct, but here we’re only going to store a string for the prompt and a string for the answer.

    
    static var example: Card {
        Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
