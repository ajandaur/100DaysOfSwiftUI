//
//  User.swift
//  FriendFace
//
//  Created by Anmol  Jandaur on 12/22/20.
//

import Foundation
import SwiftUI

struct LoadedUser: Codable, Identifiable {
    var id: String
    var name: String
    var age: Int
    var company: String
    var isActive: Bool
    var friends: [LoadedFriend]
    
}
