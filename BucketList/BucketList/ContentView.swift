//
//  ContentView.swift
//  BucketList
//
//  Created by Anmol  Jandaur on 12/28/20.
//

import SwiftUI
import LocalAuthentication

// access MapKit's data types
import MapKit

struct ContentView: View {
    
    // property that tracks whether the app has been unlocked
    @State private var isUnlocked = true
    
    // property that tracks whether the biometric authentication failed
    @State private var biometricFailed = false
    // property for the error message
    @State private var errorMessage = ""
    
    // authenticate function to handle biometric work
    func authenticate() {
        // Creating an LAContext so we have something that can check and perform biometric authentication.
        let context = LAContext()
        var error: NSError?
        
        // Ask it whether the current device is capable of biometric authentication.
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            // If it is, start the request and provide a closure to run when it completes.
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                // When the request finishes, push our work back to the main thread and check the result.
                DispatchQueue.main.async {
                    if success {
                        // If it was successful, we’ll set isUnlocked to true so we can run our app as normal.
                        self.isUnlocked = true
                    } else {
                        // MARK: Challenge 3 - Our app silently fails when errors occur during biometric authentication. Add code to show those errors in an alert
                        biometricFailed = true
                        errorMessage = authenticationError?.localizedDescription ?? "Unknown error occurred"
                        
                    }
                }
            }
        } else {
            // no biometric
        }
    }

    var body: some View {
        ZStack {
            if isUnlocked {
                
                MapCircleButtonView()
                
            } else {
                // button that triggers the authenticate() method
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        } // ZStack
        .alert(isPresented: $biometricFailed) {
            Alert(title: Text("Authentication Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
       
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
