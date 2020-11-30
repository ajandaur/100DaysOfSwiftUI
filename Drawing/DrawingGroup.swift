//
//  DrawingGroup.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 11/29/20.
//

import SwiftUI

struct DrawingGroup: View {
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
        }
    }
    
}

// We can get a color cycling effect by using the Color(hue:saturation:brightness:) initializer: hue is a value from 0 to 1 controlling the kind of color we see – red is both 0 and 1, with all other hues in between. To figure out the hue for a particular circle we can take our circle number (e.g. 25), divide that by how many circles there are (e.g. 100), then add our color cycle amount (e.g. 0.5). So, if we were circle 25 of 100 with a cycle amount of 0.5, our hue would be 0.75.
struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
//                    .strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
                
                //  Replace the existing strokeBorder()modifier with this one:
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
                
                // This renders a slow app because SwiftUI is rendering 1000 gradients as part of 100 separate views
                
            }
        }
        
        // Fix this by applying drawingGroup() -> this tells SwiftUI to render the content of thev iew in an off-screen image before putting it back onto thescreen as a single rendered output -> makes it much faster and smoother
        
        .drawingGroup()
    }
    
    
    func color( for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        // wrap the hue by hand: if it’s over 1.0 we’ll subtract 1.0, to make sure it always lies in the range of 0.0 to 1.0.
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}
struct DrawingGroup_Previews: PreviewProvider {
    static var previews: some View {
        DrawingGroup()
    }
}
