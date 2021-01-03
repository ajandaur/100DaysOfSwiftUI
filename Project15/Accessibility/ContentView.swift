//
//  ContentView.swift
//  Accessibility
//
//  Created by Anmol  Jandaur on 12/31/20.
//

import SwiftUI

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    
    let labels = [
    "Tulips",
    "Frozen tree buds",
    "Sunflowers",
    "Fireworks"
    ]

    @State private var selectedPicture = Int.random(in: 0...3)
    
    @State private var estimate = 25.0
    
    @State private var rating = 3

    var body: some View {
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            
            // controls VoiceOver by reading a label immediately
            .accessibility(label: Text(labels[selectedPicture]))
            
            // fix problem of image acting like a button by using addTraits modifier to explain that it is a button
            .accessibility(removeTraits: .isImage)
            .onTapGesture {
                self.selectedPicture = Int.random(in: 0...3)
            }
        
        // group views so that the system reads it as one view
        // provide a custom label the parent
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.title)
            
            // Customizing slider to modify read out of value
            Slider(value: $estimate, in: 0...50)
                .padding()
                .accessibility(value: Text("\(estimate)"))
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("Your score is 1000"))
        
        // VoiceOver doesn't read out stepper unless modifier is added
        Stepper("Rate of our service: \(rating)/5", value: $rating, in: 1...5)
            .accessibility(value: Text("\(rating) out of 5"))
        
            // makes view completely invisible to the accessibility system
            Image(decorative: "character")
                .accessibility(hidden: true)
      
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
