//
//  Mission.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/24/20.
//

//Every mission has an ID number
//Every mission has a description
//Every mission has an array of crew, where each member has a name and role
//All but one missions has a launch date

import Foundation

struct Mission: Codable, Identifiable {
    // assets are accessed as apollo 1, apollo2, and so on..
    // add computed properties here so  any other views can use the same data without having to repeat our string interpolation code, which in turn means if we change the way these things are formatted
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    
    // nested struct -> Mission.CrewRole
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let crew: [CrewRole]
    let description: String

    // change to Date? from String? after decoding code
    let launchDate: Date?
    
    // ask the mission class to provide a formatted launch date that converts the optional date into a neatly formatted string or sends back “N/A” for missing dates
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }
}

