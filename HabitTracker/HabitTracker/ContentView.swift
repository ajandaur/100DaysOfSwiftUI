//
//  ContentView.swift
//  HabitTracker
//
//  Created by Anmol  Jandaur on 12/13/20.
//

import SwiftUI

// list of all activities they want to track

struct ContentView: View {
    // using @ObservedObject here asks SwiftUI to watch the object for any change announcements, so any time one of our @Published properties changes the view will refresh its body.
    @ObservedObject var activities = Activities()
    
    // to add AddActivityView as a new view, we need some state to track whether or not AddActivityView is being shown, so add this property:
    @State private var showingAddActivity = false
    
    var body: some View {
        NavigationView {
            List(0..<activities.activities.count, id:\.self) { index in
                NavigationLink(destination:ActivityDetailView(activities: self.activities, index: index)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(self.activities.activities[index].title)
                                .font(.headline)
                            Text(self.activities.activities[index].description)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("\(self.activities.activities[index].count)")
                    }
                }
            }
            .navigationBarTitle(Text("Habit Tracker"))
            .navigationBarItems(trailing:
                                    Button(action: {
                                        self.showingAddActivity = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            )
            .sheet(isPresented: $showingAddActivity) {
                AddActivityView(activites: self.activities)
            }
            
        } // NavigationView
    } // Body
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
