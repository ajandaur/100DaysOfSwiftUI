//
//  ContentView.swift
//  Flashzilla
//
//  Created by Anmol  Jandaur on 1/12/21.
//

import SwiftUI
import Foundation

struct ContentView: View {
 
    // create test array of stack of cards
    @State private var cards = [Card](repeating: Card.example, count: 10)
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor

    
    // takes an index in our cards array and removes that item
    // this connects to the closure on the CardView()
    func removeCard(at index: Int) {
        cards.remove(at: index)
    }
    
    var body: some View {
    
        ZStack {
            
            // Around that VStack will be another ZStack, so we can place our cards and timer on top of a background.
            Image("background")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack {
                    // Our stack of cards will be placed inside a ZStack so we can make them partially overlap with a neat 3D effect.
                    
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView(card: self.cards[index]) {
                            withAnimation {
                                self.removeCard(at: index)
                            }
                        }
                            .stacked(at: index, in: self.cards.count)
                    }
                }
            }
            
            if differentiateWithoutColor {
                VStack {
                    Spacer()
                    
                    HStack {
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        
    }
}

extension View {
    //  stacked() modifier that takes a position in an array along with the total size of the array, and offsets a view by some amount based on those values.
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
