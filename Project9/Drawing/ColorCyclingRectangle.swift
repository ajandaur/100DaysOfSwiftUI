//
//  ColorCyclingRectangle.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 12/3/20.
//

import SwiftUI

// Challenge 3 - Create a ColorCyclingRectangle shape that is the rectangular cousin of ColorCyclingCircle, allowing us to control the position of the gradient using a property.

struct ColorCyclingRectangle: View {
    @State private var amount = 0.0
    
    var body: some View {
        VStack {
            CycleRectangle(amount: amount)
            
            Slider(value: $amount)
        }
    }
}

struct CycleRectangle: View {
     var amount = 0.0
     var steps = 100
    
    var body: some View {
        ZStack {
                  ForEach(0..<steps) { value in
                      Rectangle()
                      .inset(by: CGFloat(value))
                      .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                          self.color(for: value, brightness: 1),
                          self.color(for: value, brightness: 0.5)
                      ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
                  }
              }
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

struct ColorCyclingRectangle_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingRectangle()
    }
}
