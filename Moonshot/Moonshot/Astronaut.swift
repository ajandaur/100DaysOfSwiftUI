//
//  Astronaunt.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/24/20.
//

import Foundation

// convert the astronaut data int oa Swift struct

// Identifiable -> so we can use arrays of astronauts inside ForEach
// Codable -> create instances
struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
}
