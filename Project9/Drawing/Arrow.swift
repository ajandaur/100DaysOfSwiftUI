//
//  Arrow.swift
//  Drawing
//
//  Created by Anmol  Jandaur on 12/1/20.
//


import SwiftUI

struct Arrow: View {
    
    // set thickness for which the animation begins
    @State private var insetAmount: CGFloat = 4
    
    var body: some View {
        ArrowShape(insetAmount: insetAmount)
            
            // Challenge 2: Make the line thickness of your Arrow shape animatable.
            .stroke(Color.blue, style: StrokeStyle(lineWidth: insetAmount * 8, lineCap: .round, lineJoin: .bevel))
            .frame(width: 200, height: 300)
        // animation trigger
            .overlay(ArrowShape(insetAmount:  insetAmount).foregroundColor(.orange))
            .onTapGesture {
                withAnimation(.spring(response: 2.5, dampingFraction: 0.6, blendDuration: 3)) {
                    self.insetAmount = CGFloat.random(in: 2...10)
                }
            }
    }
    
    // Challenge 1: Create an Arrow shape made from a rectangle and a triangle – having it point straight up is fine.

    struct ArrowShape: Shape {
        var insetAmount: CGFloat
        
        var animatableData: CGFloat {
            get { insetAmount }
            set { self.insetAmount = newValue }
        }
            
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addRect(CGRect(x: rect.maxX / 4, y: rect.midY, width: rect.maxX / 2, height: rect.maxY / 2))
            
            return path
        }
    }
    
}



struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
    }
}
