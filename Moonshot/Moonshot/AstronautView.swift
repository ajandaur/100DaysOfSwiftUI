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
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    
                    Text(self.astronaut.description)
                        .padding()
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautVIew_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("atronaunts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
