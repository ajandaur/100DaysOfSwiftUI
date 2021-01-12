//
//  ContentView.swift
//  HotProspects
//
//  Created by Anmol  Jandaur on 1/9/21.
//

import SwiftUI

// this is where we're going to store TabView that contains other views

struct ContentView: View {
 
    // store single instance of Prospects class
    var prospects = Prospects()
    
    var body: some View
    {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Everyone")
                }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Contacted")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Image(systemName: "questionmark.diamond")
                    Text("Uncontacted")
                    
                }
            MeView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Me")
                }
        }
        // allow all the child views to access prospects var
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
