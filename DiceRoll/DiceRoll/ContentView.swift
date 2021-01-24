//
//  ContentView.swift
//  DiceRoll
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI
import CoreData



struct ContentView: View {
    

    var body: some View {
   
        //  tab view where the first tab lets users roll dice, and the second tab shows results from previous rolls.
        TabView {
            
            PlayView()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Play")
                }
                .tag("roll")

            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag("history")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
