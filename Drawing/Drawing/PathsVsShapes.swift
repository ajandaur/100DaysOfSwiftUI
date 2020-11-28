//
//  PathsVsShapes.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 11/28/20.
//

import SwiftUI

struct PathsVsShapes: View {
    var body: some View {
        Triangle()
            .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .frame(width: 300, height: 300)
        
        Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
            .stroke(Color.blue, lineWidth: 10)
            .frame(width: 300, height: 300)
    }
}


// SwiftUI implements Shape as a protocol with a single required method: given the following rectangle, what path do you want to draw? This will still create and return a path just like using a raw path directly, but because we’re handed the size the shape will be used at we know exactly how big to draw our path – we no longer need to rely on fixed coordinates.
struct Triangle : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

// create an Arc shape that accepts three parameters: start angle, end angle, and whether to draw the arc clockwise or not. This might seem simple enough, particularly because Path has an addArc() method
struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        // In the eyes of SwiftUI 0 degrees is not straight upwards, but instead directly to the right.
        
        //  Shapes measure their coordinates from the bottom-left corner rather than the top-left corner, which means SwiftUI goes the other way around from one angle to the other. 
        
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2,startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
}

struct PathsVsShapes_Previews: PreviewProvider {
    static var previews: some View {
        PathsVsShapes()
    }
}
