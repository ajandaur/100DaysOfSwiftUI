//
//  Activities.swift
//  HabitTracker
//
//  Created by Anmol  Jandaur on 12/14/20.
//

import Foundation

class Activities: ObservableObject {
    // use Codable and UserDefaults to load and save all your data.
    
    // To allow user data to load again implement a custom initializer that will..
    init() {
        // Attempt to read the “Activities” key from UserDefaults.
        if let activities = UserDefaults.standard.data(forKey: "Activities") {
            // Create an instance of JSONDecoder, which lets us go from JSON data to Swift objects.
            let decoder = JSONDecoder()
            // Ask the decoder to convert the data we received from UserDefaults into an array of Activity objects.
            if let decoded = try? decoder.decode([Activity].self, from: activities) {
                // that worked, assign the resulting array to items and exit.
                self.activities = decoded
                return
            }
        }
        // Otherwise, set items to be an empty array.
        self.activities = []
    }
    
    @Published var activities: [Activity] {
        didSet {
            // create an instance of JSONEncoder that converts our data to JSON
            let encoder = JSONEncoder()
            // try encoding our items array
            if let encoded = try? encoder.encode(activities) {
                // write to UserDefaults using the key "Items"
                UserDefaults.standard.set(encoded, forKey: "Activities")
            }
        }
    }
    
}
