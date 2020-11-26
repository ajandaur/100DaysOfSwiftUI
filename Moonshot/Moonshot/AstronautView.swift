//
//  AstronautView.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/26/20.
//

//  make a third and final view to display astronaut details, which will be reached by tapping one of the astronauts in the mission view

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    // Challenge 2: Modify AstronautView to show all the missions this astronaut flew on.
    var missionsCompleted: [Mission]
    
    // Challenge 2: Use a custom init to loops over all the missions and figuring out whether to astronuat was a part of that mission.
    init(missions: ListOfMissions, astronaut: Astronaut, missionsCompleted: [Mission]) {
        self.astronaut = astronaut
            
            var matches = [Mission]()
            
        for mission in missions.ListOfMissions {
                // if the missions we are looping over have a crew member whose name is the same as the astronaut we are initializing, append the mission to matches
                if mission.crew.contains(where: { $0.name == astronaut.id} ) {
                    matches.append(mission)
                }
            }
            // set the matches array to the missionCompleted array
            self.missionsCompleted = matches
        }
                
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    // Challenge 2: list all the missions this astronaut has been on
                    Text("Missions Flown: ")
                        .font(.caption2)
                    HStack {
                        ForEach(self.missionsCompleted) { mission in
                            Text(mission.displayName)
                        }
                    }
                    .font(.caption)
                    
                    Text(self.astronaut.description)
                        .padding()
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("atronaunts.json")
    static let missions = ListOfMissions()
    
    static var previews: some View {
        AstronautView(missions: missions, astronaut: astronauts[0], missionsCompleted: [Mission(id: 3, crew: [Mission.CrewRole(name: "Drew Baldwin", role: "Pilot")], description: "Testing", launchDate: nil)])
    }
}
