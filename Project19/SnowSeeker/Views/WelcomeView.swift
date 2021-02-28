//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Anmol  Jandaur on 1/20/21.
//

import SwiftUI

// It is not immediately obvious to the user that they need to slide from the left to reveal the list of options. In UIKit this can be fixed easily, but SwiftUI doesn’t give us an alternative right now so we’re going to work around the problem: we’ll create a second view to show on the right by default, and use that to help the user discover the left-hand list

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)

            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
