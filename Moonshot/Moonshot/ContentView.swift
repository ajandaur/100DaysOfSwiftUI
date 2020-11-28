//
//  ContentView.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    
    // used extension here instead of a method..
    // Because we are using generics, use type annotation so Swift knows exactly what type we are decoding
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    // Challenge 3: toggle between launch date and crew names using a state var
    @State private var showCrew = true
    
    // Create dictionary of crew members by mission
    // Key:Value pair
    var crew: [String: String] {
           var membersByMission = [String: String]()
           var members = ""
           
            // Loop through the missions
           for mission in missions {
               // each member in the mission's crew, add the name of members string
               for member in mission.crew {
                   members += member.name.capitalized + ", "
               }
                // replace the displayName of the mission with the members
                // We are able to do so because Mission.displayName is a computed property
               membersByMission[mission.displayName] = members
               members = ""
           }
        
        // return the dictionary
           return membersByMission
       }
    
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(
                    destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    // Mission name
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                    // Missions subtitle: date or crew members
                        Text(self.showCrew ? self.crew[mission.displayName] ?? "" : mission.formattedLaunchDate)
                            .font(.subheadline)
                    
                    }
                }
                .navigationBarTitle("Moonshot")
                
                // Challenge 3: make a bar button in ContentView that toggles between showing launch dates and showing crew names
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.showCrew.toggle()
                                        }) {
                                            self.showCrew ? Text("Launch Date") : Text("Crew")
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
