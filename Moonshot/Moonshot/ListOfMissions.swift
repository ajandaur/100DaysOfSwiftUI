//
//  ListOfMissions.swift
//  Moonshot
//
//  Created by Anmol  Jandaur on 11/26/20.
//

import Foundation

class ListOfMissions: ObservableObject {
    @Published var ListOfMissions: [Mission] = Bundle.main.decode("missions.json")
}
