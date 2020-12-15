//
//  AnimatableData.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 11/29/20.
//

// We’ve now covered a variety of drawing-related tasks, and back in project 6 we looked at animation, so now I want to look at putting those two things together.

import SwiftUI

struct AnimatableData: View {
    @State private var insetAmount: CGFloat = 50
    var body: some View {
        Trapezoid(insectAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                
                // What you should see is that it prints out 2.0, 3.0, 4.0, and so on. At the same time, the button is scaling up or down smoothly – it doesn’t just jump straight to scale 2, 3, and 4. What’s actually happening here is that SwiftUI is examining the state of our view before the binding changes, examining the target state of our views after the binding changes, then applying an animation to get from point A to point B.”
                
                withAnimation {
                self.insetAmount = CGFloat.random(in: 10...90)
                }
                
                // What’s happening here is quite complex: when we use withAnimation(), SwiftUI immediately changes our state property to its new value, but behind the scenes it’s also keeping track of the changing value over time as part of the animation. As the animation progresses, SwiftUI will set the animatableData property of our shape to the latest value, and it’s down to us to decide what that means – in our case we assign it directly to insetAmount, because that’s the thing we want to animate.
            }
    }
}

// build a custom shape we can use for an example – here’s the code for a trapezoid shape, which is a four-sided shape with straight sides where one pair of opposite sides are parallel:

struct Trapezoid: Shape {
    
    // Remember, SwiftUI evaluates our view state before an animation was applied and then again after. It can see we originally had code that evaluated to Trapezoid(insetAmount: 50), but then after a random number was chosen we ended up with (for example) Trapezoid(insetAmount: 62). So, it will interpolate between 50 and 62 over the length of our animation, each time setting the animatableData property of our shape to be that latest interpolated value – 51, 52, 53, and so on, until 62 is reached.
    var animatableData: CGFloat {
        get { insectAmount }
        set { self.insectAmount = newValue }
    }
    
    var insectAmount: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insectAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insectAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y:rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}

struct AnimatableData_Previews: PreviewProvider {
    static var previews: some View {
        AnimatableData()
    }
}
