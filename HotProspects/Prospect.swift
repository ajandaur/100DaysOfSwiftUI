//
//  Prospect.swift
//  HotProspects
//
//  Created by Anmol  Jandaur on 1/11/21.
//

import Foundation

// class rather than struct because we are going to change instances of the class directly and have it updated by other views at the same time
class Prospect: Identifiable, Codable, Comparable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    
    // fileprivate(set), which means “this property can be read from anywhere, but only written from the current file”
    fileprivate(set) var isContacted = false
    
    // operator overloading for sorting
    static func <(lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name < rhs.name
    }
    
    static func ==(lhs: Prospect, rhs: Prospect) -> Bool {
        lhs.name == rhs.name && lhs.id == rhs.id && lhs.emailAddress == rhs.emailAddress && lhs.isContacted == rhs.isContacted
    }
}

class Prospects: ObservableObject {
    // people array in Prospects is marked with @Published, which means if we add or remove items from that array a change notification will be sent out. However, if we quietly change an item inside the array then SwiftUI won’t detect that change, and no views will be refreshed
    @Published private(set) var people: [Prospect]
    
    // create a static property on Prospects to contain our save key, so we use that property rather than a string for UserDefaults.
    static let saveKey = "SavedData"
    
    // method to flip the boolean of isContacted while also sending a change notification out
    func toggle(_ prospect: Prospect) {
        // send notification that an item will change
        objectWillChange.send()
        prospect.isContacted.toggle()
        // Calling save() when toggling its isContacted property.
        save()
    }
    
    
    // encapsulation for adding prospect to array property and also save()
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }

    // MARK: initialize and load JSON data
    init() {
        self.people = []
         
        // load data
        let filename = self.getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        
        do {
            // use Data(contentsOf:) and JSONDecoder() to load our data
            let data = try Data(contentsOf: filename)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            
        } catch {
            print("Unable to load saved data")
        }
    }
    
    // MARK: Challenge 2 - Use JSON and the documents directory for saving and loading our user data.
    
    // MARK: Use local storage
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    // MARK: save JSON data
    func save() {
        let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        
        do {
            
            let encoded = try JSONEncoder().encode(self.people)
            // iOS ensures the file is written with encryption so that it can only be read once the user has unlocked their device. This is in addition to requesting atomic writes.
            try encoded.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            print("Data was saved to \(filename)")
        } catch {
            print("Unable to save data.")
        }
    }
    
    func sortUsername() {
        self.people = self.people.sorted()
        save()
    }
    
    // MARK: Using local UserDefaults, switched to document directory above
    
    // Adding a save() method to the same class, writing the current data to UserDefaults.
    private func saveUserDefaults() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    // loads data to UserDefaults
    private func loadUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
            
            }
        }
    }
   
}
