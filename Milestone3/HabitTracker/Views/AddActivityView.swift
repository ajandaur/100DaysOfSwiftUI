//
//  AddActivityView.swift
//  HabitTracker
//
//  Created by Anmol  Jandaur on 12/14/20.
//

import SwiftUI

// a form to add new activities – a title and description should be enough.

struct AddActivityView: View {
    // // dismissing AddActivityView is done by storing a reference to the view’s presentation mode, then calling dismiss() on it when the time is right.
    @Environment(\.presentationMode) var presentationMode
    
    // add property to store an Activities object
    @ObservedObject var activites: Activities
    
    // Check for invalid input of name and description
    @State private var isInvalidInput = false
    
    @State private var activityTitle = ""
    @State private var activityDescription = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Activity Title", text: $activityTitle)
                TextField("Activity Description", text: $activityDescription)
            } // Form
            .navigationBarTitle("Add new habit")
            .navigationBarItems(trailing:
                                    Button("Save") {
                                        if self.activityTitle != "" && self.activityDescription != ""
                                        {
                                            let activity = Activity(title: self.activityTitle, description: self.activityDescription, count: 1)
                                            self.activites.activities.append(activity)
                                            
                                            // causes the showingAddActivity Boolean in ContentView
                                            // to go back to false, and hides the AddActivityView
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            self.isInvalidInput.toggle()
                                        }
                                    })
            // Show an alert to explain invalid input error
            .alert(isPresented: $isInvalidInput) {
                Alert(title: Text("Input is invalid"), message: Text("You didn't enter a description or title! Please try again."), dismissButton: .default(Text("Continue")))
            }
        } // NavigationView
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(activites: Activities())
    }
}
