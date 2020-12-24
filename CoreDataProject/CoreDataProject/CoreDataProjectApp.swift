//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Anmol  Jandaur on 12/19/20.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
