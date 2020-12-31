//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Anmol  Jandaur on 12/20/20.
//

import SwiftUI
import CoreData

struct FilteredList: View {
    var fetchRequest: FetchRequest<Singer>
    // MARK: Challenge 1 - create a property to build a sortDescriptor array - to keep it simple it will sort on lastname either ascending or descending
    var sortDescriptor: [NSSortDescriptor]

    // MARK: Challenge 1 - add a sortAscending parameter to the initializer
    init(sortAscending: Bool, filter: String, predicateMethod: predicateMethod) {
        
    // MARK: Challenge 3 - use switch statement to resolve the enum to a string to pass into NSPredicate
        var predicateChoice = ""
        
        switch predicateMethod {
        case .beginsWith:
            predicateChoice = "BEGINSWITH"
        case .beginsWithAnyCase:
            predicateChoice = "BEGINSWITH[c]"
        case .contains:
            predicateChoice = "CONTAINS"
        case .containsAnyCase:
            predicateChoice = "CONTAINS[c]"
        }
        
        
        sortDescriptor = [NSSortDescriptor(keyPath: \Singer.lastName, ascending: sortAscending)]
        
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: sortDescriptor, predicate: NSPredicate(format: "lastName \(predicateChoice) %@", filter))
    }
    
    // wrapped value for singers to make code more simple
    var singers: FetchedResults<Singer> { fetchRequest.wrappedValue }
    
    var body: some View {
        List(singers, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
}
