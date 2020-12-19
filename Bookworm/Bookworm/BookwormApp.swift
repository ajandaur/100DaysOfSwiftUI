//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Anmol  Jandaur on 12/18/20.
//

import SwiftUI

@main
struct BookwormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
