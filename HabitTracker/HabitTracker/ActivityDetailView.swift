//
//  ActivityDetailView.swift
//  HabitTracker
//
//  Created by Anmol  Jandaur on 12/14/20.
//

import SwiftUI

// tapping one of the activities should show a detail screen with the description, how many times they have completed it, plus a button incrementing their completion count.

// Present your adding form using sheet(), and your activity detail view (if you add one) using NavigationLink.

struct ActivityDetailView: View {
    @ObservedObject var activities: Activities
    var index: Int
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Activity Description: \(self.activities.activities[index].description)")
                    .font(.headline)
                    .padding(10)
                Text("Streak Count: \(self.activities.activities[index].count)")
                    .font(.headline)
                    .padding()
                Button("Increase streak by 1") {
                    var count = self.activities.activities[index].count
                    count += 1
                    self.activities.activities[index].count = count
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(Text(self.activities.activities[index].title),displayMode: .inline)
    }
}


