//
//  DieView.swift
//  DiceRoll
//
//  Created by Anmol  Jandaur on 1/24/21.
//

import SwiftUI

struct DieView: View {
    
    var die: Int
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var backgroundColor: Color
    

    var body: some View {
        Text("\(die)")
            .frame(width: self.width, height: self.height)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius).stroke(Color.black, lineWidth: 2))
            .font(backgroundColor == Color.yellow ? . title : .headline)
            .accessibility(label: Text("\(die)"))
    }
}

struct DieView_Previews: PreviewProvider {
    static var previews: some View {
        DieView(die: 0, width: 100, height: 100, cornerRadius: 25, backgroundColor: .green)
    }
}
