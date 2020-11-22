//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Anmol  Jandaur on 11/21/20.
//

import Foundation

// First, we need to decide what an expense is – what do we want it to store? In this instance it will be three things: the name of the item, whether it’s business or personal, and its cost as an integer.

// Identifiable = “this type can be identified uniquely.”
// Requirements:  there must be a property called id that contains a unique identifier.
// having Identifiable no longer forces us to use this nasty id: /.id stuff!
struct ExpenseItem: Identifiable, Codable {
    
    // ask Swift to generate a UUID automatically for us..
    // don’t need to worry about the id value of our expense items
    // Swift will make sure they are always unique.
    var id = UUID()
    
    let name: String
    let type: String
    let amount: Int
    // Challenge 2: create property to get index of type of color to make the cost
    let costStyleIndex: Int
}

