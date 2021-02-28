//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Anmol  Jandaur on 1/21/21.
//

import SwiftUI

// Creating a new Favorites class that has a Set of resort IDs the user likes.

// MARK: Challenge 2 - Fill in the loading and saving methods for Favorites

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var resorts: Set<String>
    
    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"
    
    init() {
        // load our saved data from UserDefaults
        if let items = UserDefaults.standard.data(forKey: saveKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Set<String>.self, from: items) {
                print(decoded)
                self.resorts = decoded
                return
            }
        }
    
        // still here? Use an empty array
        self.resorts = []
    }
    
    // Giving it add(), remove(), and contains() methods that manipulate the data, sending update notifications to SwiftUI while also saving any changes to UserDefaults.

    //return true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // adds the resort to our set, updates all views, and saves the change
       func add(_ resort: Resort) {
           objectWillChange.send()
           resorts.insert(resort.id)
           save()
       }
    
    // removes the resort from our set, updates all views, and saves the changes
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        // write out our data
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(resorts) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}
