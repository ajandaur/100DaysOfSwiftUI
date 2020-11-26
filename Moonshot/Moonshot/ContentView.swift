//
//  ContentView.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var missions = ListOfMissions()
    
    // Challenge 3: toggle between launch date and crew names using a state var
    @State private var showCrew = false
    
    
    // used extension here instead of a method..
    // Because we are using generics, use type annotation so Swift knows exactly
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(
                    destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                        HStack {
                            if self.showCrew {
                                ForEach(mission.crew, id: \.role) { member in
                                    HStack {
                                        Text(member.name.capitalized)
                                    }
                                }
                            } else {
                                Text(mission.formattedLaunchDate)
                            }
                        }
                    }
                }
                .navigationBarTitle("Moonshot")
                
                // Challenge 3: make a bar button in ContentView that toggles between showing launch dates and showing crew names
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.showCrew.toggle()
                                        }) {
                                            self.showCrew ? Text("Crew") : Text("Launch Date")
                                        }
                )
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
