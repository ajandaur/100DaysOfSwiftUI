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
    
    func incrementCounter() {
        var count = self.activities.activities[index].count
        count += 1
        self.activities.activities[index].count = count
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Activity Description: \(self.activities.activities[index].description)")
                    .font(.headline)
                    .padding()
                Button(action: incrementCounter) {
                    Image(systemName: "\(activities.activities[index].count).circle.fill")
                        .resizable()
                        .scaledToFit()
                        .overlay(
                                Circle()
                                    .stroke(Color.secondary, lineWidth: 1.2)
                        )
                        .frame(width: 200, height: 100, alignment: .center)
                        .foregroundColor(.blue)
                  
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(Text(self.activities.activities[index].title),displayMode: .inline)
    }
}



struct ActivityDetailView_Previews: PreviewProvider {
    static let activity = Activity(id: UUID(), title: "test", description: "testing", count: 0)
    static var previews: some View {
        ActivityDetailView(activities: Activities(), index: 0)
    }
}
