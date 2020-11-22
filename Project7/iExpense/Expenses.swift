//
//  Expenses.swift
//  iExpense
//
//  Created by Anmol  Jandaur on 11/21/20.
//

import Foundation

// Now that we have something that represents a single expense, the next step is to create something to store an array of those expense items inside a single object. This needs to conform to the ObservableObject protocol, and we’re also going to use @Published to make sure change announcements get sent whenever the items array gets modified.
class Expenses: ObservableObject {
    
    // To allow user data to load again implement a custom initializer that will..
    init() {
        // Attempt to read the “Items” key from UserDefaults.
        if let items = UserDefaults.standard.data(forKey: "Items") {
            // Create an instance of JSONDecoder, which lets us go from JSON data to Swift objects.
            let decoder = JSONDecoder()
            // Ask the decoder to convert the data we received from UserDefaults into an array of ExpenseItem objects.
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                // that worked, assign the resulting array to items and exit.
                self.items = decoded
                return
            }
        }
        // Otherwise, set items to be an empty array.
        self.items = []
    }
    
    @Published var items : [ExpenseItem] {
        didSet {
            // create an instance of JSONEncoder that converts our data to JSON
            let encoder = JSONEncoder()
            // try encoding our items array
            if let encoded = try? encoder.encode(items) {
                // write to UserDefaults using the key "Items"
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

//  We’re going to leverage four important technologies to help us save and load data in a clean way:
//
//  The Codable protocol: allow us to archive all the existing expense items ready to be stored.
//  UserDefault: which will let us save and load that archived data.
//  A custom initializer for the Expenses class: when we make an instance of it we load any saved data from UserDefaults
//  A didSet property observer on the items property of Expenses: whenever an item gets added or removed we’ll write out changes.
