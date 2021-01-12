//
//  Prospect.swift
//  HotProspects
//
//  Created by Anmol  Jandaur on 1/11/21.
//

import Foundation

// class rather than struct because we are going to change instances of the class directly and have it updated by other views at the same time
class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    
    // fileprivate(set), which means “this property can be read from anywhere, but only written from the current file”
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    // people array in Prospects is marked with @Published, which means if we add or remove items from that array a change notification will be sent out. However, if we quietly change an item inside the array then SwiftUI won’t detect that change, and no views will be refreshed
    @Published private(set) var people: [Prospect]
    
    // create a static property on Prospects to contain our save key, so we use that property rather than a string for UserDefaults.
    static let saveKey = "SavedData"
    
    // method to flip the boolean of isContacted while also sending a change notification out
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        // Calling save() when toggling its isContacted property.
        save()
    }
    
    // Adding a save() method to the same class, writing the current data to UserDefaults.
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    // encapsulation for adding prospect to array property and also save()
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }

    // Updating the Prospects initializer so that it loads its data from UserDefaults where possible.
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        
        
        self.people = []
    }
    
   
}
