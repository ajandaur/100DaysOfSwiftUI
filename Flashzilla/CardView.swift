//
//  CardView.swift
//  Flashzilla
//
//  Created by Anmol  Jandaur on 1/13/21.
//

import SwiftUI

struct CardView: View {
    var card: Card
    
    // connected closure for contentView()
    var removal: (() -> Void)? = nil
    
    // property for showing answer
    @State private var isShowingAnswer = false

    //  environment property to track whether we should be using color for accessibility
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    
    // track how much the user dragged
    @State private var offset = CGSize.zero
    
    var body: some View {
        
        // VStack for the two labels, inside a ZStack with a white RoundedRectangle.
        
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                
                // a background of the same rounded rectangle except in green or red depending on the gesture movement, then we’ll make the white fill from above fade out as the drag movement gets larger
                
                .fill(
                    differentiateWithoutColor
                        ? Color.white
                        : Color.white
                        .opacity(1 - Double(abs(offset.width / 50)))
                        )
            
                .background(
                    differentiateWithoutColor
                    ? nil
                        : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? Color.green : Color.red)
                )
                // add shadow to add a depth effect
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundColor(.gray)
                }
                
                
                Text("Percentage Correct: \(card.percentageCorrect, specifier: "%.1f")")
                    .font(.subheadline)
                

            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        // A width of 450 is no accident: the smallest iPhones have a landscape width of 480 points, so this means our card will be fully visible on all devices.
        .frame(width: 450, height: 250)
        
        // REMEMBER: Order of modifiers matters!
        // put rotation first then the offset
        .rotationEffect(.degrees(Double(offset.width / 5)))
        
        // we’re not going to use the original value of offset.width because it would require the user to drag a long way to get any meaningful results, so instead we’re going to multiply it by 5 so the cards can be swiped away with small gestures.
        .offset(x: offset.width * 5, y: 0)
        
        // We’re going to take 1/50th of the drag amount, so the card doesn’t fade out too quickly.
        // We then use this result to subtract from 2.
        .opacity(2 - Double(abs(offset.width / 50)))
        
        // attach a DragGesture to our card so that it updates offset as the user drags the card around.
        //  We are reading the translation property to see where the user has dragged to, and we’ll be using that to set our offset property
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
            
                .onEnded { _ in
                    if abs(self.offset.width) > 100 {
                        // removal is only called when the closure has been set
                        self.removal?()
            
                        
                    } else {
                        self.offset = .zero
                    }
                }
            )
        
        // add onTapGesture()
        .onTapGesture {
            isShowingAnswer.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
