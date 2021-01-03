//
//  MissionView.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/24/20.
//

import SwiftUI

struct MissionView: View {
    
    let mission: Mission
    
    // on one side we have missions that know crew member “armstrong” had the role “Commander”, but has no idea who “armstrong” is, and on the other side we have “Neil A. Armstrong” and a description of him, but no concept that he was the commander on Apollo 11.
    
    // make the MissionView accept the mission that got tapped, along with our full astronauts array, then have it figure out which astronauts actually took part in the launch
    
    let astronauts: [CrewMember]
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
// we can loop over the mission crew, then for each crew member loop over all our astronauts to find the one that has a matching ID. When we find one we can convert that and their role into a CrewMember object, but if we don’t it means somehow we have a crew role with an invalid or unknown name.
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
    
            // first(where:) can be given a predicate (a fancy word for a condition), and it will send back the first array element that matches the predicate, or nil if none do. In our case we can use that to say “give me the first astronaut with the ID of armstrong.”
            
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }

    
    // show information about the mission: its image, its mission badge, and all the astronauts that were on the crew along with their roles
   
    var body: some View {
        // use GeometryReader to set the maximum width of the mission image
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                    
                        .accessibility(hidden: true)
                    
                    // Challenge 1: add launch date below mission badge image.
                    VStack {
                        Text("Mission Launch Date:")
                        Text(mission.formattedLaunchDate)
                    }
                    .font(.caption)
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("Mission Launch Date: mission.formattedLaunchDate"))

                
                    
                    Text(self.mission.description)
                        .padding()
                    
                    // Now that we have all our astronaut data, we can show this directly below the mission description using a ForEach
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView( astronaut: crewMember.astronaut, missionsCompleted: [self.mission])) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                    .accessibility(hidden: true)
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                }
                                .accessibilityElement(children: .ignore)
                                .accessibility(label: Text("\(crewMember.astronaut.name)"))
                                .accessibility(hint: Text("\(crewMember.role)"))
                                
                                Spacer()
                            } // HStack
                            .padding(.horizontal)
                        } // NavigationLink
                        
                        // ask SwiftUI to render the contents of the navigation link as a plain button, which means it won’t apply coloring to the image or text
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    
                    
                    
                    // minLength ensures the spacer has a minimum height of at least 25 points.
                    // This is helpful inside scroll views because the total available height is flexible: a spacer would normally take up all available remaining space, but that has no meaning inside a scroll view.
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
}


struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
