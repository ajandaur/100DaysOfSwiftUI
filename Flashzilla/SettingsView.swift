//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Anmol  Jandaur on 1/16/21.
//

import SwiftUI

// MARK: Challenge 2 - Add a settings screen that has a single option: when you get an answer one wrong that card goes back into the array so the user can try it again.
struct SettingsView: View {
    
    @Binding var retryCards: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("when you get an answer one wrong that card goes back into the deck")) {
                    Toggle(isOn: $retryCards) {
                        Text("Retry incorrect cards")
                    }
                }
            }
            .navigationBarTitle("Settings")

        }
        
    }
}
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView(retryCards: Binding.constant(false))
        }
    }
