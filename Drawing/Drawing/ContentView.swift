//
//  ContentView.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 11/28/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // if you want to use a path by itself you either need to accept that sizing across all devices or use something like GeometryReader to scale them relative to their container.
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y:300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y:100))

        }
        // Can fill
//        .fill(Color.red)
        
        // draw around the path
//        .stroke(Color.blue, lineWidth: 10)
        
        // An alternative is to use SwiftUI’s dedicated ShapeStyle struct, which gives us control over how every line should be connected to the line after it (line join) and how every line should be drawn when it ends without a connection after it (line cap). This is particularly useful because one of the options for join and cap is .round, which creates gently rounded shapes:
        .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
