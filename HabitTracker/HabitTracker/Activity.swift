//
//  Activity.swift
//  HabitTracker
//
//  Created by Anmol  Jandaur on 12/14/20.
//

import Foundation

// Identifiable = “this type can be identified uniquely.”
// Requirements:  there must be a property called id that contains a unique identifier.
struct Activity: Identifiable, Codable
{
    // Swift will make sure they are always unique, using UUID
    var id: UUID = UUID()
    
    // title of habit
    let title: String
    
    //description of habit
    let description: String
    
    // streak count
    var count: Int
}
