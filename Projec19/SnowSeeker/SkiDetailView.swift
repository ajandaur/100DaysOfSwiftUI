//
//  SkiDetailView.swift
//  SnowSeeker
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI

struct SkiDetailView: View {
    let resort: Resort
    
    var body: some View {
        
        // To make our two child views layout neutral – to make them have no specific layout direction of their own, but instead be directed by their parent – we need to make them use Group rather than VStack
        
        Group {
            // our text is important, and should be even increased priority when it comes to layout
            Text("Elevation: \(resort.elevation)m").layoutPriority(1)
            // tell the spacers we only want them to work in landscape mode – they shouldn’t try to add space vertically.
            Spacer().frame(height: 0)
            Text("Snow: \(resort.snowDepth)cm").layoutPriority(1)
        }
    }
}

struct SkiDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SkiDetailView(resort: Resort.example)
    }
}
