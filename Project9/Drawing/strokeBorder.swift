//
//  strokeBorder.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 11/28/20.
//

import SwiftUI

struct strokeBorder: View {
    var body: some View {
        Circle()
        // That changes stroke() to strokeBorder() and now we get a better result: all our border is visible, because Swift strokes the inside of the circle rather than centering on the line.
            .strokeBorder(Color.blue, lineWidth: 40)
        
        Arc2(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
            .strokeBorder(Color.blue, lineWidth: 40)
    }
    
}

// To make Arc conform to InsettableShape we need to add one extra method to it: inset(by:). This will be given the inset amount (half the line width of our stroke), and should return a new kind of insettable shape – in our instance that means we should create an inset arc. The problem is, we don’t know the arc’s actual size, because path(in:) hasn’t been called yet.
struct Arc2: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    // give our Arc shape a new insetAmount property that defaults to 0, we can just add to that whenever inset(by:) is called. Adding to the inset allows us to call inset(by:) multiple times if needed, for example if we wanted to call it once by hand then use strokeBorder()
    var insetAmount: CGFloat = 0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }

    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
//        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
}

struct strokeBorder_Previews: PreviewProvider {
    static var previews: some View {
        strokeBorder()
    }
}
